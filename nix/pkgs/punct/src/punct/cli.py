"""punct command-line interface."""

from __future__ import annotations

from typing import NoReturn

import click
from rich.prompt import Confirm, IntPrompt
from rich.table import Table

from . import __version__, config, nix
from .console import console, err_console


@click.group()
@click.version_option(__version__, prog_name="punct")
def main() -> None:
    """Manage this host's home-manager configuration."""


@main.command()
@click.argument("name", required=False)
@click.option(
    "--flake",
    "flake_ref",
    default=".",
    show_default=True,
    help="Flake reference containing homeConfigurations.",
)
def onboard(name: str | None, flake_ref: str) -> None:
    """Pick a homeConfigurations entry and persist it for this host."""
    if config.state_exists():
        existing = config.load_state()
        console.print(
            "[yellow]This host is already onboarded as "
            + f"[bold]{existing.config_name}[/bold]. "
            + "Pick a new configuration to replace it.[/yellow]"
        )

    try:
        with console.status("[cyan]Evaluating flake…[/cyan]", spinner="dots"):
            system = nix.current_system()
            configs = nix.enumerate_configurations(flake_ref)
    except nix.NixError as exc:
        _fail(str(exc))

    matching = sorted(n for n, sys in configs.items() if sys == system)
    if not matching:
        _fail(f"no homeConfigurations in {flake_ref!r} match this system ({system}).")

    chosen = _select_config(name, matching, system)

    state = config.HostState.create(
        config_name=chosen,
        flake_ref=nix.resolve_flake_ref(flake_ref),
        system=system,
    )

    path = config.save_state(state)
    console.print(
        f"[green]Onboarded as [bold]{chosen}[/bold][/green] "
        + f"([dim]{system}[/dim]) -> {path}"
    )


def _select_config(name: str | None, matching: list[str], system: str) -> str:
    """Resolve the chosen config name from an arg or an interactive picker."""
    if name is not None:
        if name not in matching:
            options = ", ".join(matching)
            _fail(
                f"{name!r} is not a configuration for this system ({system}). "
                + f"Available: {options}"
            )
        return name

    if len(matching) == 1:
        only = matching[0]
        if Confirm.ask(
            f"Use the only matching configuration, [bold]{only}[/bold]?",
            default=True,
        ):
            return only
        raise SystemExit(0)

    table = Table(title=f"Configurations for {system}")
    table.add_column("#", justify="right", style="cyan")
    table.add_column("Configuration", style="bold")
    for index, cfg in enumerate(matching, start=1):
        table.add_row(str(index), cfg)
    console.print(table)

    choice = IntPrompt.ask(
        "Select a configuration",
        choices=[str(i) for i in range(1, len(matching) + 1)],
        show_choices=False,
    )
    return matching[choice - 1]


@main.command()
@click.option("--no-diff", is_flag=True, help="Skip the nvd diff preview.")
def switch(no_diff: bool) -> None:
    """Run home-manager switch against the onboarded configuration."""
    try:
        state = config.load_state()
    except config.ConfigError as exc:
        _fail(str(exc))

    if not no_diff:
        _preview_diff(state, required=False)

    console.print(f"[cyan]Switching to [bold]{state.flake_url}[/bold]…[/cyan]")
    try:
        code = nix.home_manager_switch(state.flake_url)
    except nix.NixError as exc:
        _fail(str(exc))

    if code != 0:
        raise SystemExit(code)


@main.command()
def diff() -> None:
    """Diff the current generation against the flake, before switching."""
    try:
        state = config.load_state()
    except config.ConfigError as exc:
        _fail(str(exc))

    _preview_diff(state, required=True)


def _preview_diff(state: config.HostState, *, required: bool) -> None:
    """Build the target generation and show an nvd diff against the current one.

    When ``required`` is False (e.g. a first-ever switch), a missing current
    generation is a skipped diff rather than an error.
    """
    current = nix.current_home_generation()
    if current is None:
        message = "no active home-manager generation found"
        if required:
            _fail(f"{message}. Run [bold]punct switch[/bold] at least once first.")
        console.print(f"[yellow]{message}; skipping diff.[/yellow]")
        return

    console.print(f"[cyan]Building [bold]{state.config_name}[/bold]…[/cyan]")
    try:
        target = nix.build_home_generation(state.flake_ref, state.config_name)
    except nix.NixError as exc:
        _fail(str(exc))

    if current == target:
        console.print("[green]Already up to date — no changes to apply.[/green]")
        return

    try:
        code = nix.nvd_diff(current, target)
    except nix.NixError as exc:
        _fail(str(exc))

    if code != 0:
        raise SystemExit(code)


@main.command()
def status() -> None:
    """Show the onboarded configuration for this host."""
    if not config.state_exists():
        console.print(
            "[yellow]This host is not onboarded.[/yellow] "
            + "Run [bold]punct onboard[/bold] to get started."
        )
        return

    try:
        state = config.load_state()
    except config.ConfigError as exc:
        _fail(str(exc))

    table = Table(show_header=False, title="punct status")
    table.add_column(style="cyan")
    table.add_column(style="bold")
    table.add_row("Configuration", state.config_name)
    table.add_row("Flake", state.flake_ref)
    table.add_row("System", state.system)
    table.add_row("Onboarded", state.onboarded_at)
    console.print(table)


@main.command()
@click.option(
    "--older-than",
    "older_than",
    type=click.IntRange(min=0),
    default=14,
    show_default=True,
    help="Delete generations older than this many days.",
)
@click.option(
    "--dry-run", is_flag=True, help="Show what would be deleted without deleting."
)
@click.option("--yes", is_flag=True, help="Skip the confirmation prompt.")
def gc(older_than: int, dry_run: bool, yes: bool) -> None:
    """Collect nix garbage older than N days (default 14)."""
    if not dry_run and not yes:
        proceed = Confirm.ask(
            f"Delete generations older than [bold]{older_than}[/bold] days "
            + "and collect garbage?",
            default=False,
        )
        if not proceed:
            console.print("Left unchanged.")
            return

    try:
        code = nix.collect_garbage(older_than, dry_run=dry_run)
    except nix.NixError as exc:
        _fail(str(exc))

    if code != 0:
        raise SystemExit(code)


def _fail(message: str) -> NoReturn:
    """Print an error and exit non-zero."""
    err_console.print(f"[red]error:[/red] {message}")
    raise SystemExit(1)


if __name__ == "__main__":
    main()

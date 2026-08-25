"""Subprocess wrappers around ``nix`` and ``home-manager``.

This module is the sole boundary between punct and the external Nix
toolchain, keeping subprocess handling out of the CLI layer.
"""

from __future__ import annotations

import getpass
import json
import os
import subprocess
from pathlib import Path
from typing import cast

# Maps each homeConfigurations entry to the Nix system it builds for.
_ENUMERATE_APPLY = "builtins.mapAttrs (n: c: c.pkgs.stdenv.hostPlatform.system)"


class NixError(Exception):
    """Raised when an underlying nix/home-manager command fails."""


def resolve_flake_ref(ref: str) -> str:
    """Turn a local flake path into an absolute one, leaving remotes untouched.

    ``.`` or any existing local path becomes its absolute form so the stored
    reference keeps working from any directory. Remote refs (``github:...``,
    ``git+https://...``, etc.) are returned unchanged.
    """
    candidate = ref[len("path:") :] if ref.startswith("path:") else ref

    # Remote refs carry a scheme like ``github:``; treat as local only when the
    # ref looks like a filesystem path.
    is_local = candidate.startswith((".", "/", "~")) or ":" not in candidate
    if not is_local:
        return ref

    expanded = Path(candidate).expanduser()
    if expanded.exists():
        return str(expanded.resolve())
    return ref


def current_system() -> str:
    """Return the current Nix system string, e.g. ``aarch64-darwin``."""
    result = _run(
        ["nix", "eval", "--impure", "--raw", "--expr", "builtins.currentSystem"]
    )
    system = result.strip()
    if not system:
        raise NixError("nix returned an empty current system")
    return system


def enumerate_configurations(flake_ref: str) -> dict[str, str]:
    """Return a mapping of ``{config_name: system}`` for the given flake.

    Raises:
        NixError: if the flake has no ``homeConfigurations`` or eval fails.
    """
    output = _run(
        [
            "nix",
            "eval",
            f"{flake_ref}#homeConfigurations",
            "--apply",
            _ENUMERATE_APPLY,
            "--json",
        ]
    )
    try:
        data = cast(object, json.loads(output))
    except json.JSONDecodeError as exc:
        raise NixError(f"could not parse nix eval output: {exc}") from exc

    if not isinstance(data, dict):
        raise NixError("expected an attribute set of homeConfigurations")

    items = cast(dict[object, object], data)
    return {str(name): str(system) for name, system in items.items()}


def home_manager_switch(flake_url: str) -> int:
    """Run ``home-manager switch --flake <flake_url>`` interactively.

    Streams output straight to the terminal and returns the exit code.
    """
    proc = subprocess.run(
        ["home-manager", "switch", "--flake", flake_url],
        check=False,
    )
    return proc.returncode


def home_manager_build(flake_url: str) -> int:
    """Run ``home-manager build --flake <flake_url>`` interactively.

    Builds the configuration (producing a ``result`` symlink) without
    activating it. Streams output straight to the terminal.
    """
    proc = subprocess.run(
        ["home-manager", "build", "--flake", flake_url],
        check=False,
    )
    return proc.returncode


def current_home_generation() -> str | None:
    """Resolve the store path of the active home-manager generation.

    Returns ``None`` if no home-manager profile is found (i.e. this host has
    never run a switch).
    """
    xdg_state = os.environ.get("XDG_STATE_HOME")
    state_dir = Path(xdg_state) if xdg_state else Path.home() / ".local/state"
    candidates = [
        state_dir / "nix/profiles/home-manager",
        Path("/nix/var/nix/profiles/per-user") / getpass.getuser() / "home-manager",
    ]
    for candidate in candidates:
        if candidate.exists():
            return str(candidate.resolve())
    return None


def build_home_generation(flake_ref: str, config_name: str) -> str:
    """Build a config's activation package and return its store path.

    Builder progress (nix's stderr) streams straight to the terminal; only the
    store path (nix's stdout) is captured.
    """
    attr = f"{flake_ref}#homeConfigurations.{config_name}.activationPackage"
    cmd = ["nix", "build", attr, "--no-link", "--print-out-paths"]
    try:
        proc = subprocess.run(
            cmd,
            check=False,
            stdout=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError as exc:
        raise NixError(f"command not found: {cmd[0]}") from exc
    if proc.returncode != 0:
        raise NixError(f"`{' '.join(cmd)}` failed (exit {proc.returncode})")
    lines = [line.strip() for line in proc.stdout.splitlines() if line.strip()]
    if not lines:
        raise NixError("nix build produced no output path")
    return lines[-1]


def collect_garbage(older_than_days: int, *, dry_run: bool) -> int:
    """Run ``nix-collect-garbage --delete-older-than <N>d``, streaming output."""
    cmd = ["nix-collect-garbage", "--delete-older-than", f"{older_than_days}d"]
    if dry_run:
        cmd.append("--dry-run")
    try:
        proc = subprocess.run(cmd, check=False)
    except FileNotFoundError as exc:
        raise NixError(f"command not found: {cmd[0]}") from exc
    return proc.returncode


def nvd_diff(old_path: str, new_path: str) -> int:
    """Show an nvd diff between two generation store paths."""
    proc = subprocess.run(
        ["nvd", "diff", old_path, new_path],
        check=False,
    )
    return proc.returncode


def _run(cmd: list[str]) -> str:
    """Run a command, capturing stdout; raise NixError on failure."""
    try:
        proc = subprocess.run(
            cmd,
            check=True,
            capture_output=True,
            text=True,
        )
    except FileNotFoundError as exc:
        raise NixError(f"command not found: {cmd[0]}") from exc
    except subprocess.CalledProcessError as exc:
        stderr = cast(str, exc.stderr or "").strip()
        raise NixError(f"`{' '.join(cmd)}` failed:\n{stderr}") from exc
    return proc.stdout

# punct

A small CLI for managing this host's [home-manager](https://github.com/nix-community/home-manager)
configuration. `punct` remembers which entry from the flake's
`homeConfigurations` this machine uses, then gives you short, safe commands to
preview and apply it — so you don't retype `home-manager switch --flake '.#…'`
or guess what a switch will change.

## Commands

| Command | What it does |
| --- | --- |
| `punct onboard [NAME] [--flake REF]` | Pick a `homeConfigurations` entry (filtered to this system) and persist it. `--flake` defaults to `.`; local paths are stored as absolute paths. |
| `punct switch [--no-diff]` | Show an `nvd` diff of what will change, then run `home-manager switch`. `--no-diff` skips the preview. |
| `punct build` | Build the configuration (`home-manager build`, producing a `result` symlink) without activating it. |
| `punct diff` | Build the target generation and show an `nvd` diff against the current one, without switching. |
| `punct gc [--older-than DAYS] [--dry-run] [--yes]` | Wrapper around `nix-collect-garbage --delete-older-than`. Defaults to 14 days. |
| `punct status` | Show the saved configuration for this host. |

## Getting started

Cold start on a fresh box (before anything is installed):

```sh
nix run github:zakko/punctuation#punct -- onboard --flake github:zakko/punctuation
```

If you have a local checkout, point at it instead (stored as an absolute path):

```sh
punct onboard --flake .
```

Then day to day:

```sh
punct diff      # preview
punct switch    # apply (previews first unless --no-diff)
punct gc        # tidy up generations older than 14 days
```

## Where things live

State is stored at `$XDG_CONFIG_HOME/punctuation/config.toml` (defaulting to
`~/.config/punctuation/config.toml`) and holds the chosen configuration name,
the flake reference, the system, and when it was onboarded.

`punct` is packaged in this repo at `nix/pkgs/punct` (`buildPythonApplication`,
Click + Rich + Pydantic + tomlkit). It's installed via `home.packages` for
everyday use and exposed as a flake app (`nix run .#punct`) for cold starts. The
binary is wrapped so `nix`, `home-manager`, and `nvd` are always on its runtime
PATH, and it ships zsh/bash/fish completions.

## Development

The dev shell provides `uv`, `ruff`, `basedpyright`, and `punct` itself:

```sh
uv sync              # set up the local venv
uv run punct --help
uv run ruff check src
uv run basedpyright
```

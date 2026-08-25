# AGENTS.md

This repo holds a home-manager flake. It ships a CLI called **punct** that
manages which `homeConfigurations` entry a host uses and applies it.

## Use punct to switch

Once a host is onboarded, prefer punct over raw home-manager commands:

- `punct diff` — preview what a switch would change (builds the target, shows an
  `nvd` diff against the current generation). **Run this before switching.**
- `punct switch` — apply the config. It shows the diff first, then runs
  `home-manager switch`. Pass `--no-diff` to skip the preview.
- `punct build` — build the config without activating it (`home-manager build`),
  useful to check it compiles.
- `punct status` — show the host's saved configuration.
- `punct onboard [NAME] [--flake .]` — pick and persist a configuration. Only
  needed once per host (or to change which config a host uses).
- `punct gc [--older-than DAYS]` — collect old nix generations (default 14 days).

If `punct` is not on PATH (fresh box, before the first switch), run it via the
flake app: `nix run .#punct -- <command>`.

State lives at `~/.config/punctuation/config.toml`.

## Working on punct itself

The CLI source is at `nix/pkgs/punct` (Python, `buildPythonApplication`, Click +
Rich + Pydantic + tomlkit). See `nix/pkgs/punct/README.md` for details.

Before committing changes to punct, run from `nix/pkgs/punct`:

```sh
uv run ruff check src
uv run ruff format --check src
uv run basedpyright
```

All three must pass clean (0 errors, 0 warnings). Inside the nix dev shell,
prefix these with `env -u PYTHONPATH` — the dev shell puts the packaged `punct`
on `PYTHONPATH`, which otherwise shadows the local uv venv. New files must be `git add`ed
for the Nix flake to see them (flakes only read tracked files).

# punct

Manage which `homeConfigurations` entry a host uses, and run `home-manager switch`
against it.

## Cold start (no local install yet)

```sh
nix run github:zakko/punctuation#punct -- onboard --flake github:zakko/punctuation
```

## Everyday use (installed via home.packages)

```sh
punct onboard [NAME] [--flake .]   # pick and persist a configuration
punct switch                       # home-manager switch against the saved config
punct status                       # show the saved state
```

State is stored at `$XDG_CONFIG_HOME/punctuation/config.toml`
(defaults to `~/.config/punctuation/config.toml`).

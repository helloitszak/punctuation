"""Persistent host state: load/save the onboarded configuration.

State lives at ``$XDG_CONFIG_HOME/punctuation/config.toml`` (defaulting to
``~/.config/punctuation/config.toml``). It is modelled as a Pydantic model and
read/written with tomlkit so future edits can preserve formatting/comments.
"""

from __future__ import annotations

import os
from datetime import UTC, datetime
from pathlib import Path
from typing import ClassVar

import tomlkit
from pydantic import BaseModel, ConfigDict, ValidationError
from tomlkit.exceptions import TOMLKitError


class ConfigError(Exception):
    """Raised when the on-disk state is missing or malformed."""


class HostState(BaseModel):
    """The onboarded configuration for this host."""

    model_config: ClassVar[ConfigDict] = ConfigDict(extra="forbid", frozen=True)

    config_name: str
    flake_ref: str
    system: str
    onboarded_at: str

    @property
    def flake_url(self) -> str:
        """The ``<ref>#<name>`` string passed to ``home-manager switch``."""
        return f"{self.flake_ref}#{self.config_name}"

    @classmethod
    def create(cls, config_name: str, flake_ref: str, system: str) -> HostState:
        """Build a state object stamped with the current UTC time."""
        now = datetime.now(UTC).replace(microsecond=0).isoformat()
        return cls(
            config_name=config_name,
            flake_ref=flake_ref,
            system=system,
            onboarded_at=now,
        )


def config_dir() -> Path:
    """The XDG-aware configuration directory for punct."""
    xdg = os.environ.get("XDG_CONFIG_HOME")
    base = Path(xdg) if xdg else Path.home() / ".config"
    return base / "punctuation"


def config_path() -> Path:
    """Full path to the state TOML file."""
    return config_dir() / "config.toml"


def load_state() -> HostState:
    """Read and validate the persisted state.

    Raises:
        ConfigError: if the file is absent, unparseable, or fails validation.
    """
    path = config_path()
    if not path.exists():
        raise ConfigError(
            f"no configuration found at {path}. Run 'punct onboard' first."
        )

    try:
        document = tomlkit.parse(path.read_text())
    except (OSError, TOMLKitError) as exc:
        raise ConfigError(f"could not read {path}: {exc}") from exc

    try:
        return HostState.model_validate(document.unwrap())
    except ValidationError as exc:
        raise ConfigError(f"{path} is not valid punct state:\n{exc}") from exc


def state_exists() -> bool:
    """Whether a state file is present on disk."""
    return config_path().exists()


def save_state(state: HostState) -> Path:
    """Write state to disk, creating the config directory as needed."""
    path = config_path()
    path.parent.mkdir(parents=True, exist_ok=True)

    document = tomlkit.document()
    document["config_name"] = state.config_name
    document["flake_ref"] = state.flake_ref
    document["system"] = state.system
    document["onboarded_at"] = state.onboarded_at
    _ = path.write_text(tomlkit.dumps(document))
    return path

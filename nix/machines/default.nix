{ config-name, ... }:
let
  # if-exists = f: builtins.pathExists f;
  if-exists = f: true;
  existing-imports = imports: builtins.filter if-exists imports;
in {
  imports = existing-imports [
    ./${config-name}.nix
  ];
}

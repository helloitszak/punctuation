{
  lib,
  python3Packages,
  makeWrapper,
  installShellFiles,
  nix,
  home-manager,
  nvd,
}:
python3Packages.buildPythonApplication {
  pname = "punct";
  version = "0.1.0";
  pyproject = true;
  src = ./.;

  build-system = [python3Packages.hatchling];

  dependencies = with python3Packages; [
    click
    rich
    pydantic
    tomlkit
  ];

  nativeBuildInputs = [makeWrapper installShellFiles];

  # Generate shell completions from the freshly-built (pre-wrap) binary.
  postInstall = ''
    installShellCompletion --cmd punct \
      --zsh <(_PUNCT_COMPLETE=zsh_source $out/bin/punct) \
      --bash <(_PUNCT_COMPLETE=bash_source $out/bin/punct) \
      --fish <(_PUNCT_COMPLETE=fish_source $out/bin/punct)
  '';

  # punct shells out to `nix`, `home-manager`, and `nvd` at runtime.
  postFixup = ''
    wrapProgram $out/bin/punct \
      --prefix PATH : "${lib.makeBinPath [nix home-manager nvd]}"
  '';

  # No test suite yet; ensure the entry point at least imports.
  pythonImportsCheck = ["punct"];

  meta = {
    description = "Manage which homeConfigurations entry a host uses and run home-manager switch";
    mainProgram = "punct";
  };
}

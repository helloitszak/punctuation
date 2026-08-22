{
  pkgs,
  nixpkgs,
  dotroot,
  ...
}: {
  imports = [
    ./vim.nix
    ./git.nix
    ./shell.nix
    ./misc.nix
    ./development.nix
  ];

  nix = {
    registry.nixpkgs.flake = nixpkgs;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # We always deploy nvd everywhere since it's needed for diffing
  home.packages = with pkgs; [
    nvd
    # punct manages which homeConfigurations entry this host uses
    punct
  ];

  # Home manager always manages itself
  programs.home-manager.enable = true;
}

{pkgs, ...}: {
  imports = [
    ../home-modules/default.nix
  ];

  home = {
    username = "zakko";
    homeDirectory = "/Users/zakko";
  };

  home.stateVersion = "25.11";
}

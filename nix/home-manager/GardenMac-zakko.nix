{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    bazelisk
  ];

  imports = [
    ../home-modules/default.nix
  ];

  home = {
    username = "zakko";
    homeDirectory = "/Users/zakko";
  };

  home.stateVersion = "25.11";
}

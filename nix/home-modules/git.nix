{pkgs, ...}: {
  programs.git.enable = true;
  programs.git.userEmail = "zak.kristjanson@gmail.com";
  programs.git.userName = "Zak Kristjanson";

  home.packages = with pkgs; [
    local.git-gud
    gh
  ];
}

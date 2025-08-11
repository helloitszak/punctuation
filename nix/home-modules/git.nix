{pkgs, ...}: {
  programs.git = {
    enable = true;
    userEmail = "zak.kristjanson@gmail.com";
    userName = "Zak Kristjanson";
    delta.enable = true;
  };

  home.packages = with pkgs; [
    local.git-gud
    gh
  ];
}

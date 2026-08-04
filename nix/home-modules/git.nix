{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      email = "zak.kristjanson@gmail.com";
      name = "Zak Kristjanson";
    };
  };

  home.packages = with pkgs; [
    git-gud
    gh
  ];
}

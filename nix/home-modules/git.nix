{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      email = "zak.kristjanson@gmail.com";
      name = "Zak Kristjanson";
    };
    settings.init.defaultBranch = "main";
  };

  home.packages = with pkgs; [
    git-gud
    gh
  ];
}

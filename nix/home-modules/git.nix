{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      email = "zak.kristjanson@gmail.com";
      name = "Zak Kristjanson";
    };
    settings.init.defaultBranch = "main";
    settings.url."git@github.com:".insteadOf = [
      "https://github.com/"
      "http://github.com/"
    ];
  };

  home.packages = with pkgs; [
    git-gud
    gh
  ];
}

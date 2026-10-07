{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      email = "git@rabbit.garden";
      name = "Zak Kristjanson";
    };
    settings.init.defaultBranch = "main";
    settings.url."git@github.com:".pushInsteadOf = [
      "https://github.com/"
      "http://github.com/"
    ];
  };

  home.packages = with pkgs; [
    git-gud
    gh
  ];
}

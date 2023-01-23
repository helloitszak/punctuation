{
  pkgs,
  dotroot,
  ...
}: {
  home.packages = with pkgs; [
    zsh
    starship
  ];

  home.file.".zshenv".source = "${dotroot}/dotfiles/zshenv";

  xdg.configFile."zsh" = {
    recursive = true;
    source = "${dotroot}/dotfiles/zsh";
  };

  xdg.configFile."zsh/plugins/zsh-async" = {
    recursive = true;
    source = pkgs.local.sources.zsh-async.src;
  };

  xdg.configFile."zsh/plugins/zsh-syntax-highlighting" = {
    recursive = true;
    source = pkgs.local.sources.zsh-syntax-highlighting.src;
  };

  xdg.configFile."zsh/plugins/zsh-history-substring-search" = {
    recursive = true;
    source = pkgs.local.sources.zsh-history-substring-search.src;
  };
}

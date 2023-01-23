{
  pkgs,
  dotroot,
  ...
}: {
  imports = [
    ./zsh.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    vim
    git
    exa
    fd
    sd
    fzf
    bat
    # httpie
    curl
    jq
    nushell
    ripgrep
    rustup
    tree
    youtube-dl
    local.git-gud
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Home manager always manages itself
  programs.home-manager.enable = true;
}
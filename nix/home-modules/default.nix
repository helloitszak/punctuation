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
    nodejs
    ffmpeg
    bash
    nmap
    inetutils
    aria2
    vim
    # exa # TODO: something
    fd
    sd
    fzf
    bat
    yt-dlp
    mpv
    # httpie
    curl
    jq
    nushell
    ripgrep
    rustup
    tree
    youtube-dl
    minikube
    kubectl
    cmake
    ipcalc
    _1password
    pwgen
    local.proxmark3-rrg
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Home manager always manages itself
  programs.home-manager.enable = true;
}

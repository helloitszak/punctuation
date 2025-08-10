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
    wget
    jq
    nushell
    ripgrep
    rustup
    tree
    yt-dlp
    minikube
    vfkit
    kubectl
    krew
    cmake
    ipcalc
    _1password-cli
    pwgen
    local.proxmark3-rrg
    devenv
    numbat
    poetry
    kind
    hurl
    pipx
    sshpass
    devenv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Home manager always manages itself
  programs.home-manager.enable = true;
}

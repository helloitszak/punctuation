{
  pkgs,
  ...
}: {
  programs.starship.enable = true;
  # programs.starship.

  # TODO: Look into bringing in custom zsh config here
  programs.zsh.enable = true;
  
  # This is on by default, but enables the random programs to automatically
  # integrate with zsh.
  home.shell.enableShellIntegration = true;
  home.shell.enableZshIntegration = true;


  # TODO: Figure out how to make /Users/zakko/.nix-profile/bin/zsh a real thing

  # TODO: Look into zsh configuration
  # https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh/default.nix


  # Better cat, with syntax highlighting
  programs.bat.enable = true;

  # Better find
  programs.fd.enable = true;
  
  # Better ls
  programs.eza.enable = true;

  # Better Grep
  programs.ripgrep.enable = true;

  # Zoxide, jump around.
  programs.zoxide.enable = true;

  # Shells and core commonly used shell utilities.
  # Anything development specific should go elsewhere.
  home.packages = with pkgs; [
    # shellz
    bash
    nushell

    # coreutils but better
    duf
    sd

    # internet getting
    curl
    wget

    # random useful things
    dust
    numbat
    jq
    tree
    ipcalc
    fzf
    inetutils
    _1password-cli
    pwgen
  ];
}
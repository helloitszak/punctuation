{pkgs, config, ...}: {
  # Use XDG for everything... this will be important next version
  xdg.enable = true;

  # Better prompt
  programs.starship = {
    enable = true;
  };

  # Better history
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
  };

  # TODO: Look into bringing in custom zsh config here
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    defaultKeymap = "emacs";

    # Antidote for package manager... later.
    antidote = {
      enable = true;
      plugins = [
        "mafredri/zsh-async"
        # "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
      ];
    };

    shellAliases = {};

    # setOptions = [
    # ];

    # Keep the classic.
    logoutExtra = ''
      cat <<-EOF

      Let's initiate the survival strategy.
      EOF
    '';
  };

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

  # This isn't in stable yet...
  programs.grep.enable = true;
  programs.grep.colors = {
    mt = "37;45";
  };

  # Zoxide, jump around.
  programs.zoxide.enable = true;

  home.sessionVariables = {
    LESS = "-F -g -i -M -R -S -w -X -z-4";
  };

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
    rclone
    rsync
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

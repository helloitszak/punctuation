{pkgs, ...}: {
  # Enable mise-en-place
  programs.mise.enable = true;

  # uv is preferred for global python management
  programs.uv.enable = true;

  # We use direnv, mostly just for this flake. Anything that uses nix directly.
  # This will automatially integrate direnv with zsh.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # Once again foiled by something not in stable yet
  # programs.npm = {
  #   enable = true;
  # };

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm";
  };

  home.sessionPath = [
    "$HOME/.npm/bin"
  ];

  home.packages = with pkgs; [
    rustup
    minikube
    vfkit
    hurl
    nil
    nixd
    uv
    watch
    kubectl
    krew
    bazelisk
    nodejs
    just
    # treehouse
    #
    # Fancy code highlighting pager
    delta
  ];
}

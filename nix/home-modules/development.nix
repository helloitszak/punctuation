{
  pkgs,
  dotroot,
  ...
}: {
  # Enable mise-en-place
  programs.mise.enable = true;

  # uv is preferred for global python management
  programs.uv.enable = true;

  # We use direnv, mostly just for this flake. Anything that uses nix directly.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    rustup
    minikube
    vfkit
    hurl
  ];
}
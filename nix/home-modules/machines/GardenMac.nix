{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    bazelisk
  ];
}

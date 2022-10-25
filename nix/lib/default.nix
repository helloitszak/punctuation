{
  nixpkgs,
  home-manager,
  overlays
}: rec {
  homeConfiguration = configuration: {
    system,
    username ? "zakko",
    homeDirectory ? "/home/${username}"
  }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username homeDirectory;
      # TODO: This is half-written lol
      # configuration = configuration // 
    };
}
# This file defines overlays
{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: _prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    #
    # });
  };

  unstable-packages = final: _prev: {
    unstablePkgs = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}

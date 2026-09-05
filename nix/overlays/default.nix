# This file defines overlays
{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    #
    # });

    # Install treehouse's cobra-generated shell completions into
    # share/{zsh,bash,fish}. The zsh module adds
    # ~/.nix-profile/share/zsh/site-functions to fpath, so the
    # _treehouse function is picked up by compinit automatically.
    treehouse = inputs.treehouse.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.installShellFiles];
      postInstall =
        (old.postInstall or "")
        + ''
          installShellCompletion --cmd treehouse \
            --zsh <($out/bin/treehouse completion zsh) \
            --bash <($out/bin/treehouse completion bash) \
            --fish <($out/bin/treehouse completion fish)
        '';
    });
  };

  unstable-packages = final: _prev: {
    unstablePkgs = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}

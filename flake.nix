{
  description = "Home Configuration and Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    treehouse = {
      url = "github:kunchenguid/treehouse/v2.2.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nvd = {
      url = "sourcehut:~khumba/nvd";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    treehouse,
    flake-utils,
    nvd,
    ...
  } @ inputs: let
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    pkgsForSystem = system: nixpkgsSource:
      import nixpkgsSource {
        config.allowUnfree = true;
        inherit system;
      };

    # Helper function to generate a home configration.
    # It includes:
    # - nixpkgs with all custom overlays
    # - some extraSpecialArgs for making dotfiles themselves easier
    mkHomeConfiguration = args:
      home-manager.lib.homeManagerConfiguration {
        modules =
          [
            {
              nixpkgs = {
                overlays = [
                  inputs.self.overlays.additions
                  inputs.self.overlays.modifications
                  inputs.self.overlays.unstable-packages
                  (final: prev: {
                    # Upstream treehouse v2.2.1's test suite shells out to the
                    # no-mistakes gate script, which parses attestation JSON with
                    # python3. Its flake only declares `git` as a check input, so
                    # the checkPhase fails in the pure Nix sandbox (python3 is
                    # present on GitHub's ubuntu-latest runners but not here). Add
                    # python3 to nativeCheckInputs so the tests can run.
                    treehouse = treehouse.packages.${args.system}.default.overrideAttrs (old: {
                      nativeCheckInputs = (old.nativeCheckInputs or []) ++ [final.python3];
                    });
                  })
                ];

                # I genuinely don't know if this is needed in both places but whatever
                config.allowUnfree = true;
              };
            }
          ]
          ++ args.modules;
        extraSpecialArgs = {
          config-name = args.name;
          dotroot = ./.;
          nixpkgs = nixpkgs;
        };
        pkgs = pkgsForSystem (args.system) nixpkgs;
      };
  in {
    # Make all my custom packages available in the flake
    packages = forAllSystems (system: import ./nix/pkgs nixpkgs.legacyPackages.${system});

    # `nix run .#punct` targets the punct CLI directly (cold-start onboarding).
    apps = forAllSystems (system: {
      punct = {
        type = "app";
        program = "${(import ./nix/pkgs nixpkgs.legacyPackages.${system}).punct}/bin/punct";
      };
    });

    # Specify formatter to use for `nix fmt`.
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Custom packages and modifications as overlays
    overlays = import ./nix/overlays {inherit inputs;};

    # Reusable nixos modules
    nixosModules = import ./nix/modules/nixos;

    # Reusable home-manager modules
    homeModules = import ./nix/modules/home-manager;

    # devShells! This should setup a nice tasty bootstrap for us.
    # It's meant to be the thing that direnv drops you into.
    devShells = forAllSystems (system: {
      default = let
        pkgs = nixpkgs.legacyPackages.${system};
        punct = (import ./nix/pkgs pkgs).punct;
      in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            home-manager.packages.${system}.default
            # punct itself
            punct
            # punct development tooling
            python3
            uv
            ruff
            basedpyright
          ];
        };
    });

    homeConfigurations = {
      "GardenMac" = mkHomeConfiguration {
        name = "GardenMac2";
        system = "aarch64-darwin";
        modules = [
          ./nix/home-manager/GardenMac-zakko.nix
        ];
      };

      "ZakbookM1" = mkHomeConfiguration {
        name = "ZakbookM1";
        system = "aarch64-darwin";
        modules = [
          ./nix/home-manager/ZakbookM1-zakko.nix
        ];
      };
    };
  };
}

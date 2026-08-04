{
  description = "Home Configuration and Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            home-manager.packages.${system}.default
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
    };
  };
}

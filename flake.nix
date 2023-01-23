{
  description = "Zak's Home Configuration and Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    nvfetcher,
    alejandra,
    ...
  }: let
    local-pkgs = import ./nix/local {};

    overlays = [
      local-pkgs.overlay
      nvfetcher.overlays.default
    ];

    pkgs = import nixpkgs {inherit overlays system;};
    username = "zakko";
    system = "aarch64-darwin";
  in
    {
      homeConfigurations."${username}@Zakbook-M1" = home-manager.lib.homeManagerConfiguration rec {
        inherit pkgs;

        extraSpecialArgs = {
          dotroot = ./.;
        };

        modules = [
          ./nix/home-modules/default.nix
          {
            home = {
              inherit username;
              stateVersion = "22.11";
              homeDirectory = "/home/${username}";
              packages = [
                alejandra.defaultPackage.${system}
              ];
            };
          }
        ];
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system overlays;};
      in {
        # Allow usage of local packages ad-hoc
        packages = pkgs.local // {
          home-manager = home-manager.defaultPackage.${system};
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixfmt
            alejandra.defaultPackage.${system}
            nvfetcher-bin
            home-manager.defaultPackage.${system}
          ];
        };
      }
    );
}

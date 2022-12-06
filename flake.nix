{
  description = "Zak's Home Configuration and Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

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
    ...
  }: let
      local-pkgs = import ./nix/local {};

      overlays = [
        local-pkgs.overlay
        nvfetcher.overlay
      ];

      pkgs = import nixpkgs { inherit overlays system; };
      username = "zakko";
      system = "aarch64-darwin";
    in {
      homeConfigurations."${username}@Zakbook-M1" =
        home-manager.lib.homeManagerConfiguration rec {
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
              };
            }
          ];
        };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system overlays; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixfmt
            # nvfetcher-bin
            home-manager.defaultPackage.${system}
          ];
        };
      }
    );
}

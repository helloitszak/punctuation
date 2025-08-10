{
  description = "Zak's Home Configuration and Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    nvd = {
      url = "sourcehut:~khumba/nvd";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    # nixpkgs-unstable,
    home-manager,
    flake-utils,
    nvfetcher,
    alejandra,
    nvd,
    ...
  }: let
    local-pkgs = import ./nix/local {};

    overlays = [
      local-pkgs.overlay
      nvfetcher.overlays.default
    ];

    pkgs = import nixpkgs {inherit overlays system;};
    # pkgs-unstable = import nixpkgs-unstable {inherit overlays system;};
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
            nix = {
              # make flake references to 'nixpkgs' resolve to this flake's
              # nixpkgs instead of nixpkgs-unstable.
              #
              # You can still do 'nixpkgs/nixpkgs-unstable' if you want upstream.
              registry.nixpkgs.flake = nixpkgs;
            };

            nixpkgs = {
              config = {
                allowUnfree = true;
                # allowUnfreePredicate = (_: true);
              };
            };

            home = {
              inherit username;
              stateVersion = "23.05";
              homeDirectory = "/Users/${username}";
              packages = [
                alejandra.packages.${system}.default
                nvd.defaultPackage.${system}
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
          home-manager = home-manager.packages.${system}.default;
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixfmt-rfc-style
            alejandra.packages.${system}.default
            nvfetcher-bin
            home-manager.packages.${system}.default
          ];
        };
      }
    );
}

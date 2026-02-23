{
  description = "Zak's Home Configuration and Dotfiles";

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

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      flake-utils,
      nvfetcher,
      nvd,
      ...
    }:
    let
      local-pkgs = import ./nix/local { };

      pkgsForSystem =
        system: nixpkgsSource:
        import nixpkgsSource {
          overlays = [
            local-pkgs.overlay
            nvfetcher.overlays.default
          ];
          config.allowUnfree = true;
          inherit system;
        };

      homeConfiguration =
        args:
        home-manager.lib.homeManagerConfiguration {
          modules = [
            {
              home = {
                username = "zakko";
                stateVersion = args.stateVersion;
                homeDirectory = "/Users/${username}";
              };
            }
            ./nix/home-modules/default.nix
          ];
          extraSpecialArgs = {
            config-name = args.name;
            dotroot = ./.;
            nixpkgs = nixpkgs;
          };
          pkgs = pkgsForSystem (args.system) nixpkgs;
        };

      username = "zakko";
    in
    flake-utils.lib.eachSystem
      [
        "x86-64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ]
      (system: {
        packages.home-manager = home-manager.packages.${system}.default;

        devShells.default =
          let
            pkgs = pkgsForSystem (system) nixpkgs;
          in
          pkgs.mkShell {
            buildInputs = with pkgs; [
              nixfmt-rfc-style
              home-manager.packages.${system}.default
              nvfetcher.packages.${system}.default
              (pkgs.writeShellScriptBin "test-script" ''
                echo "hello world";
              '')
            ];
          };
      })
    // {
      homeConfigurations = {
        "GardenMac" = homeConfiguration {
          name = "GardenMac";
          system = "aarch64-darwin";
          stateVersion = "25.05";
        };
        "Zakbook-M1" = homeConfiguration {
          name = "Zakbook-M1";
          system = "aarch64-darwin";
          stateVersion = "23.05";
        };
      };
    };
}

{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # For when https://github.com/NixOS/nix/pull/8892 gets merged
    flake-schemas = {
      url = "github:DeterminateSystems/flake-schemas";
    };
    extra-schemas = {
      url = "github:ElliottSullingeFarrall/extra-schemas";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    agenix = {
      url = "github:ElliottSullingeFarrall/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    catnerd = {
      url = "github:ElliottSullingeFarrall/catnerd";
      inputs = {
        snowfall-lib.follows = "snowfall-lib";
        snowfall-flake.follows = "snowfall-flake";
        nixpkgs.follows = "nixpkgs";
      };
    };

    rofi-plugins = {
      url = "github:ElliottSullingeFarrall/rofi-plugins";
      inputs = {
        snowfall-lib.follows = "snowfall-lib";
        pre-commit-hooks.follows = "pre-commit-hooks";
        nixpkgs.follows = "nixpkgs";
      };
    };
    code-insiders = {
      url = "github:iosmanthus/code-insiders-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ldz-desktop = {
      url = "github:ElliottSullingeFarrall/ldz-desktop/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.snowfall-lib.mkFlake
    {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        snowfall-flake.overlays.default
        agenix.overlays.default
        catnerd.overlays.default
        rofi-plugins.overlays.default
        code-insiders.overlays.default
        ldz-desktop.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        nix-index-database.nixosModules.nix-index
        agenix.nixosModules.default
        catnerd.nixosModules.catnerd
      ];
      homes.modules = with inputs; [
        nix-index-database.hmModules.nix-index
        agenix.homeManagerModules.default
        catnerd.homeModules.catnerd
      ];

      systems.hosts = {
        "elliotts-laptop" = {
          modules = with inputs; [
            nixos-hardware.nixosModules.framework-12th-gen-intel
          ];
        };
      };

    } // { schemas = inputs.flake-schemas.schemas // inputs.extra-schemas.schemas; };
}

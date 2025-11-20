{
  description = "NixOS configuration";

  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    substituters = [
      "https://cache.nixos.org"
      "https://cuda-maintainers.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix = {
      url = "github:e-tho/ucodenix";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.home-manager.follows = "home-manager";
    };
    nix-wallpaper = {
      url = "github:lunik1/nix-wallpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    miractl = {
      url = "github:clarkema/miractl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    #nixpkgs,
    nixpkgs,
    nur,
    home-manager,
    nixos-hardware,
    plasma-manager,
    stylix,
    sops-nix,
    ucodenix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      vineta = let
        private = import ./private;
        superSpecialArgs = {
          inherit inputs;
          private = private;
        };
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = superSpecialArgs;
          modules = [
            nixos-hardware.nixosModules.asus-zephyrus-ga401
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            #stylix.nixosModules.stylix
            ./hosts/vineta
          ];
        };
      leng = let
        private = import ./private;
        superSpecialArgs = {
          inherit inputs;
          private = private;
        };
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = superSpecialArgs;
          modules = [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-cpu-amd-zenpower
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
            ucodenix.nixosModules.default
            nur.modules.nixos.default
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            #stylix.nixosModules.stylix
            ./hosts/leng
          ];
        };
    };
  };
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    x1e-nixos-config = {
      url = "github:kuruczgy/x1e-nixos-config/v6.18";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server/6d5f074e4811d143d44169ba4af09b20ddb6937d";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld/2.0.6";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    envfs = {
      url = "github:Mic92/envfs/1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-your-shell = {
      url = "github:TroyKomodo/nix-your-shell/35bc4e53828cf7c0bee2fd00d7d7235d94f254b5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gfn-electron = {
      url = "github:troykomodo/gfn-electron/5fd24add653f0b32d837020b14aa87adf4d2be19";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    x1e-nixos-config,
    home-manager,
    alejandra,
    vscode-server,
    nix-ld,
    envfs,
    nix-your-shell,
    nixpkgs-unstable,
    gfn-electron,
    ...
  }: let
    mkSystem = {
      buildName,
      system,
      timeZone,
      extraModules ? [],
    }: let
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nix-your-shell.overlays.default
          (final: prev: {
            psst = pkgs-unstable.psst.overrideAttrs {
              postInstall = "";
            };
          })
        ];
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = pkgs;
        specialArgs = {inherit buildName timeZone;};
        modules =
          [
            home-manager.nixosModules.home-manager
            nix-ld.nixosModules.nix-ld
            envfs.nixosModules.envfs
            ./system/common.nix
            ./system/${buildName}.nix
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      thinkpad = mkSystem {
        buildName = "thinkpad";
        system = "aarch64-linux";
        timeZone = "America/Denver";
        extraModules = [
          x1e-nixos-config.nixosModules.x1e
          {
            home-manager.sharedModules = [
              gfn-electron.homeManagerModules.default
            ];
          }
        ];
      };
      server = mkSystem {
        buildName = "server";
        system = "x86_64-linux";
        timeZone = "America/Toronto";
        extraModules = [vscode-server.nixosModules.default];
      };
    };

    formatter = alejandra.defaultPackage;
  };
}

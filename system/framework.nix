{
  pkgs,
  variables,
  lib,
  ...
}: let
  fw16-kbd-uleds = pkgs.stdenv.mkDerivation {
    pname = "fw16-kbd-uleds";
    version = "master";

    src = pkgs.fetchFromGitHub {
      owner = "paco3346";
      repo = "fw16-kbd-uleds";
      rev = "master";
      hash = "sha256-1mPZl5q3/pOXEE/yO1EngrL+CYtmoZ1aTNOIpvRgmsU=";
    };

    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.systemd];

    installFlags = ["PREFIX=$(out)"];

    meta = with lib; {
      description = "FW16 keyboard backlight bridge exposing QMK modules as UPower kbd_backlight";
      homepage = "https://github.com/paco3346/fw16-kbd-uleds";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
in {
  imports = [
    ./presets/desktop.nix
  ];

  modules = {
    gnome = {
      autoLoginUser = variables.username;
    };
    nvidia.enable = true;
    raid = {
      enable = true;
      rootMdUuid = "cb37143d:d9cb8ef8:f0081246:a0716c23";
    };
    grub = {
      enable = true;
      efiDirectories = ["/boot/efi1"];
    };
    fw16-kbd-uleds.enable = true;
    home-manager.extraGroups = ["plugdev"];
  };

  services.colord.enable = true;
  environment.etc."color/icc/BOE_CQ_______NE160QDM_NZ6.icc".source = ../static/BOE_CQ_______NE160QDM_NZ6.icc;

  programs.steam.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  boot.initrd.services.lvm.enable = true;
  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/md0";
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "xfs";
  };

  fileSystems."/boot/efi1" = {
    device = "/dev/disk/by-label/efi1";
    fsType = "vfat";
  };

  system.stateVersion = "25.11";
}

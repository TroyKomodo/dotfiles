{pkgs, ...}: {
  modules = {
    audio.enable = true;
    bluetooth.enable = true;
    dns.enable = true;
    docker.enable = true;
    fingerprint.enable = true;
    gnome.enable = true;
    home-manager.enable = true;
    networking.enable = true;
    printing.enable = true;
    swap.enable = true;
    tailscale.enable = true;
    nvidia.enable = true;
    raid = {
      enable = true;
      rootMdUuid = "cb37143d:d9cb8ef8:f0081246:a0716c23";
      efiDirectories = [ "/boot/efi1" ];
    };
  };

  services.colord.enable = true;
  environment.etc."color/icc/BOE_CQ_______NE160QDM_NZ6.icc".source = ../static/BOE_CQ_______NE160QDM_NZ6.icc;

  services.fwupd.enable = true;

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
    fsType = "fat32";
  };

  system.stateVersion = "25.11";
}

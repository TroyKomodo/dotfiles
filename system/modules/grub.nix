{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.grub;
in {
  options.modules.grub = {
    enable = lib.mkEnableOption "Enable grub";

    efiDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Directories for EFI";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        mirroredBoots =
          map (path: {
            devices = ["nodev"];
            path = path;
            efiSysMountPoint = path;
          })
          cfg.efiDirectories;
      };
    };
  };
}

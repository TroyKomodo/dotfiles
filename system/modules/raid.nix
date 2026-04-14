{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.raid;
in {
  options.modules.raid = {
    enable = lib.mkEnableOption "Enable raid";

    rootMdName = lib.mkOption {
      type = lib.types.str;
      description = "Md name for root";
      default = "/dev/md0";
    };

    rootMdUuid = lib.mkOption {
      type = lib.types.str;
      description = "/ MD UUID";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = ["md_mod"];
    boot.supportedFilesystems = ["xfs" "vfat"];
    boot.initrd = {
      availableKernelModules = ["md_mod" "raid1" "raid10"];
      kernelModules = ["dm-snapshot" "md_mod"];
    };

    # RAID Configuration
    boot.swraid = {
      enable = true;
      mdadmConf = ''
        ARRAY ${cfg.rootMdName} metadata=1.2 UUID=${cfg.rootMdUuid}
      '';
    };
  };
}

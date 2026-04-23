{
  config,
  lib,
  ...
}: let
  cfg = config.modules.nvidia;
in {
  options.modules.nvidia = {
    enable = lib.mkEnableOption "nvidia GPU support";

    open = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use open source nvidia kernel modules";
    };

    datacenter = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use datacenter mode";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      description = "Which nvidia driver package to use";
    };

    profile = lib.mkOption {
      type = lib.types.enum ["server" "laptop"];
      default = "server";
      description = ''
        Usage profile. "server" keeps the GPU always-initialized for low-latency
        compute workloads. "laptop" enables runtime power management and PRIME
        offload so the dGPU can suspend when idle.
      '';
    };

    prime = lib.mkOption {
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          nvidiaBusId = lib.mkOption {
            type = lib.types.str;
            description = "PCI bus ID of the NVIDIA GPU (e.g. PCI:194:0:0)";
          };
          amdgpuBusId = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      });
      default = null;
      description = "PRIME offload configuration (laptop profile only)";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.profile == "server" || cfg.prime != null;
        message = "modules.nvidia.prime must be set when profile is \"laptop\"";
      }
    ];

    hardware.nvidia = {
      open = cfg.open;
      package = cfg.package;
      datacenter.enable = cfg.datacenter;
      nvidiaSettings = true;
      modesetting.enable = true;

      # Server: keep GPU initialized for compute latency.
      # Laptop: let it sleep.
      nvidiaPersistenced = cfg.profile == "server";

      powerManagement = {
        enable = cfg.profile == "laptop";
        finegrained = cfg.profile == "laptop";
      };

      prime = lib.mkIf (cfg.profile == "laptop") {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = cfg.prime.nvidiaBusId;
        amdgpuBusId = cfg.prime.amdgpuBusId;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];
  };
}

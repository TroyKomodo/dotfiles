{
  pkgs,
  lib,
  ...
}: {
  # Hardware
  hardware = {
    lenovo-thinkpad-t14s.enable = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
  };

  # Boot
  boot = {
    loader.systemd-boot.enable = true;

    initrd.systemd = {
      enable = true;
      emergencyAccess = true; # Not secure, but easier for debugging
    };

    # Enable some SysRq keys (80 = sync + process kill)
    # See: https://docs.kernel.org/admin-guide/sysrq.html
    kernel.sysctl."kernel.sysrq" = 80;
  };

  # Filesystems
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/PRIMARY";
      fsType = "xfs";
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # Networking
  networking.networkmanager = {
    enable = true;
    plugins = lib.mkForce [];
  };

  # Fingerprint reader
  services.fprintd.enable = true;

  # GNOME Desktop Environment
  services = {
    xserver.enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome = {
      enable = true;

      # Enable fractional scaling
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']
      '';
    };

    gnome.gnome-keyring.enable = true;
  };

  # Wayland environment
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron apps
      XDG_RUNTIME_DIR = "/run/user/$UID";
      # Required for GNOME to detect fingerprint reader
      XDG_DATA_DIRS = ["${pkgs.gdm}/share/gsettings-schemas/gdm-${pkgs.gdm.version}"];
    };

    # System packages (minimal - most should be in home-manager)
    systemPackages = with pkgs; [
      neovim
      git
      chromium
    ];

    # Remove GNOME bloatware
    gnome.excludePackages = with pkgs; [
      # Web & Communication
      epiphany
      geary

      # Media
      gnome-music
      totem
      cheese

      # Organization
      gnome-contacts
      gnome-maps
      gnome-calendar
      gnome-weather
      gnome-clocks

      # Utilities
      gnome-tour
      gnome-characters
      gnome-font-viewer
      gnome-connections
      snapshot

      # Games
      gnome-chess
      gnome-mahjongg
      gnome-mines
      gnome-sudoku
      gnome-tetravex
      iagno
      hitori
      atomix
      aisleriot
      tali
    ];
  };

  # PAM configuration for GNOME Keyring
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Power management
  services = {
    power-profiles-daemon.enable = false;
    tlp.enable = true;
  };

  # Build settings
  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  system.stateVersion = "25.11";
}

{
  pkgs,
  lib,
  config,
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

  cfg = config.modules.fw16-kbd-uleds;
in {
  options.modules.fw16-kbd-uleds = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
    boot.kernelModules = ["uleds"];

    environment.systemPackages = [fw16-kbd-uleds];

    # udev rules for hidraw access to FW16 keyboard modules (VID 32ac)
    services.udev.extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="32ac", MODE="0660", GROUP="plugdev", TAG+="uaccess"
    '';
    users.groups.plugdev = {};

    # The daemon
    systemd.services.fw16-kbd-uleds = {
      description = "Framework 16 keyboard backlight uleds bridge";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service"];
      requires = ["systemd-modules-load.service"];
      serviceConfig = {
        ExecStart = "${fw16-kbd-uleds}/bin/fw16-kbd-uleds";
        EnvironmentFile = "-/etc/fw16-kbd-uleds.conf";
        Restart = "on-failure";
        RestartSec = 2;
      };
    };

    # UPower only scans kbd backlights on startup; make sure it starts after the daemon
    systemd.services.upower = {
      after = ["fw16-kbd-uleds.service"];
      wants = ["fw16-kbd-uleds.service"];
    };
  };
}

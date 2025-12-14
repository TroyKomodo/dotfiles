{
  config,
  pkgs,
  ...
}: let
  variables = import ../variables.nix;
  theme = "Nightfox-Dark";
  iconPack = "Papirus-Dark";
in {
  imports = [
    ./common.nix
  ];

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  programs.gfn-electron.enable = true;

  home.packages = with pkgs; [
    (pkgs.chromium.override {
      commandLineArgs = "--force-dark-mode";
    })
    code-cursor
    vesktop
    psst
    gnome-tweaks
    gnomeExtensions.user-themes
    papirus-icon-theme
    nightfox-gtk-theme
  ];

  xdg.desktopEntries.psst = {
    name = "Spotify";
    exec = "${pkgs.psst}/bin/psst-gui";
    icon = "spotify";
    terminal = false;
    categories = ["Audio" "Music" "Player"];
    settings = {
      StartupWMClass = "psst-gui";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = theme;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "chromium.desktop";
      "x-scheme-handler/http" = "chromium.desktop";
      "x-scheme-handler/https" = "chromium.desktop";
    };
  };

  xdg.configFile."mimeapps.list".force = true;
  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = ["<Alt>Tab"];
      switch-applications = ["<Super>Tab"];
    };

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = ["<Super><Shift>s"];
      # Disable defaults if they conflict
      screenshot = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      screenshot = [];
      area-screenshot = [];
    };

    "org/gnome/desktop/wm/preferences" = {
      theme = theme;
    };

    "org/gnome/desktop/interface" = {
      icon-theme = iconPack;
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = theme;
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        pkgs.gnomeExtensions.user-themes.extensionUuid
      ];
    };
  };

  home.stateVersion = "25.11";
}

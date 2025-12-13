{
  config,
  pkgs,
  ...
}: let
  variables = import ../variables.nix;
in {
  imports = [
    ./common.nix
  ];

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  home.packages = with pkgs; [
    chromium
    code-cursor
    vesktop
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "chromium.desktop";
      "x-scheme-handler/http" = "chromium.desktop";
      "x-scheme-handler/https" = "chromium.desktop";
    };
  };

  xdg.configFile."mimeapps.list".force = true;

  home.stateVersion = "25.11";
}

{
  config,
  pkgs,
  ...
}: 
let
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
  ];

  home.stateVersion = "25.11";
}

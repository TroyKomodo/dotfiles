# Example: what framework.nix looks like now
{
  pkgs,
  technorino,
  ...
}: {
  modules = {
    cli-tools.enable = true;
    dev-tools.enable = true;
    fish.enable = true;
    direnv.enable = true;
    git.enable = true;
    ssh.enable = true;
    yubikey.eneble = true;

    gnome-desktop = {
      enable = true;
      extraPackages = with pkgs; [
        technorino.packages.${stdenv.hostPlatform.system}.package
        spotify
        vlc
        slack
        zoom-us
      ];
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}

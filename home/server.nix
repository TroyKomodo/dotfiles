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

  home.packages = with pkgs; [
    rustup
    llvmPackages_20.libcxxClang
    protobuf
    ffmpeg-full
    pkg-config
    bazelisk
    starpls
    buildifier
    buf
    go
    cmake
    ninja
  ];

  home.stateVersion = "25.05";
}

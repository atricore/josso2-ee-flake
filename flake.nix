{
  description = "JOSSO EE - flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    packages.${system} = import ./server/server.nix {
      inherit (pkgs) stdenv;
      inherit (pkgs) lib;
      jdk = pkgs.jdk8_headless;
    };
  in {
    inherit packages;
  };
}

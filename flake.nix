{
  description = "JOSSO EE - flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      # Define versions in the main flake file for easy updates
      jossoVersion = {
        version = "2.6.3";
        update = "11";
        sha256 = "1f0ll56vwcwsaczm6x7ylzc5jg7v4af9zklvrxv75jrgx793mf7u";
      };

      pkgs = nixpkgs.legacyPackages.${system};
      jdk = pkgs.jdk8_headless;

      # Server package build instructions
      server = with pkgs;
        import ./server/server.nix {
          inherit stdenv lib system jdk jossoVersion;
        };

      # Docker image build instructions
      docker = import ./server/container.nix {
        inherit pkgs jdk server jossoVersion;
      };

      packages = server // docker;

    in rec {
      # JOSSO Server package
      inherit packages;
      defaultPackage = packages.josso-ee;
    });
}

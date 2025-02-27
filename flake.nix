{
  description = "JOSSO EE - flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      jdk = pkgs.jdk8_headless;

      # JOSSO version and hash configuration - edit these values when updating
      jossoConfig = rec {
        version = "2.6.3";
        jossoUpdate = "2";
        sha256 = "16r6xnq0d0yvl5sgwic265bmm38xk8irwqbzz5y5vig0d2s4zwai";
        # Path to the server package file
        # Build ID is first 8 chars of hash
        getBuildId = hash: builtins.substring 0 8 hash;
        update = jossoUpdate;

      };

      # Calculate build ID from hash
      buildId = jossoConfig.getBuildId jossoConfig.sha256;

      # Complete JOSSO version information
      jossoVersion = rec {
        inherit (jossoConfig) version update jossoUpdate sha256;
        filePath = "file:///wa/iam/josso/josso2-ee-flake/tmp/josso-ee-2.6.3-SNAPSHOT-server-unix.tar.gz?invalidateCache=1";
      };

      # Server package build instructions
      server = import ./server/server.nix {
        inherit (pkgs) stdenv lib;
        inherit system jdk jossoVersion;
      };

      # Docker image build instructions
      docker = import ./server/container.nix {
        inherit pkgs jdk server jossoVersion;
      };

      packages = server // docker;

    in {
      # JOSSO Server package
      packages = {
        inherit (packages) josso-ee josso-ee-img;
        default = packages.josso-ee;
      };

    });
}

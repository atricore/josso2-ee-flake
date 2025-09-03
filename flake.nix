{
  description = "JOSSO EE - flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        jdk = pkgs.jdk8_headless;

        # JOSSO version and hash configuration - edit these values when updating
        jossoConfig = rec {
          version = "2.6.3";
          jossoUpdate = "5";
          # Path to the server package file
          # Build ID is first 8 chars of hash
          getBuildId = hash: builtins.substring 0 8 hash;
          update = jossoUpdate;
        };

        # Complete JOSSO version information
        jossoVersion = {
          inherit (jossoConfig) version update jossoUpdate;
          #sha256 = "0841y7azjba32h24241yza5rf4aznyxzbc7msw51s8rd7x566v9w";
          sha256 = "0r09kcy8ry1rvsrij44cybq9dj6fgdjz333i3rv40img029vivr2";
          filePath = "file:///wa/iam/josso/josso2-ee-flake/tmp/josso-ee-2.6.3-SNAPSHOT-server-unix.tar.gz?invalidateCache=5.3";
        };

        consoleVersion = {
          inherit (jossoConfig) version update jossoUpdate;
          sha256 = "";
          filePath = "file:///wa/iam/josso/josso2-ee-flake/tmp/josso-ee-2.6.3-SNAPSHOT-console-unix.tar.gz?invalidateCache=5.1";
        };

        # Server package build instructions
        server = import ./server/server.nix {
          inherit (pkgs) stdenv lib;
          inherit system jdk jossoVersion;
        };

        console = import ./console/console.nix {
          inherit (pkgs) stdenv lib;
          inherit system jdk consoleVersion;
        };

        # Docker image build instructions
        server-image = import ./server/container.nix {
          inherit pkgs jdk server jossoVersion;
        };

        # Docker image build instructions
        console-image = import ./console/container.nix {
          inherit pkgs jdk console consoleVersion;
        };


        packages = server // server-image // console // console-image;

      in
      {
        # JOSSO Server package
        packages = {
          inherit (packages) josso-ee josso-ee-img josso-console josso-console-img;
          default = packages.josso-ee;
        };

      });
}

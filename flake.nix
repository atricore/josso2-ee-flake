{
  description = "JOSSO EE - flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      inherit
        (rec {
          pkgs = nixpkgs.legacyPackages.${system};
          jdk = pkgs.jdk8_headless;

          # Server package build instructions
          server = with pkgs;
            import ./server/server.nix {
              inherit stdenv lib system jdk;
            };

          # Docker image build instructions
          docker = import ./server/container.nix {
            inherit pkgs jdk server;
          };

          packages = server // docker;
        })
        packages
        ;
    in rec {
      # JOSSO Server package
      inherit packages;
      defaultPackage = packages.josso-ee;
    });
}

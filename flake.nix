{
  description = "JOSSO EE - flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
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

          # Server package
          server = with pkgs;
            import ./server/server.nix {
              inherit stdenv lib system;
              jdk = jdk8_headless;
            };

          # Docker image
          docker = import ./server/container.nix {
            inherit pkgs server;
          };

          packages = server // docker;
        })
        packages
        ;
    in rec {
      # JOSSO Server package
      inherit packages;
      defaultPackage = packages.josso-ee-26;
    });
}

let
  pkgs = import <nixpkgs> {};
in {
  josso-ee-26 = import ./server.nix {
    inherit (pkgs) stdenv;
    inherit (pkgs) lib;
    jdk = pkgs.jdk8_headless;
  };
}

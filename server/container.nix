{
  pkgs,
  server,
  jdk,
  ...
}: let
  # Generif fn to buld a josso-ee docker image
  build = {
    jversion,
    jserver,
  }:
    pkgs.dockerTools.buildImage {
      name = "ghcr.io/atricore/josso-ee";
      tag = jversion;

      copyToRoot = pkgs.buildEnv {
        name = "root-image";
        paths = with pkgs; [
          jdk
          bashInteractive
          gnugrep
          gnused
          gnutar
          gzip
          wget
          procps
          coreutils
        ];
        pathsToLink = ["/bin"];
      };

      # Create needed folders and default config
      extraCommands = ''
        mkdir -p ./server/data/log
        mkdir -p ./server/system
        cp -r ${jserver}/etc ./server/
        chmod -R u+w ./server
        cp -r ${jserver}/etc/container/* ./server/etc/
      '';

      config = {
        WorkingDir = "/server";
        Cmd = [
          "${jserver}/bin/dstart"
        ];
        ExportedPorts = [8081];
        Env = [
          "JAVA_HOME=${jdk}"
          "KARAF_HOME=${jserver}"
          "KARAF_BASE=/server"
          "KARAF_DATA=/server/data"
        ];
      };
    };
in {
  josso-ee-img = build {
    jversion = "2.6.3-unstable";
    jserver = server.josso-ee;
  };
}

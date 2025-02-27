{
  pkgs,
  server,
  jdk,
  jossoVersion,
  ...
}: let
  # Generic fn to build a josso-ee docker image
  build = { version, update, jserver }:
    pkgs.dockerTools.buildImage {
      name = "ghcr.io/atricore/josso-ee";
      tag = "${version}-${update}";

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
        cp -r ${jserver}/extensions ./server/
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
    version = jossoVersion.version;
    update = jossoVersion.update;
    jserver = server.josso-ee;
  };
}

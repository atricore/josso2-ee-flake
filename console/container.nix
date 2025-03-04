{
  pkgs,
  console,
  jdk,
  consoleVersion,
 ...
}:  let
  # Generif fn to buld a josso-console docker image
  build = { version, update, jconsole }:
    pkgs.dockerTools.buildImage {
      name = "ghcr.io/atricore/josso-console";
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
        pathsToLink = [ "/bin" ];
      };

      # Create needed folders and default config
      extraCommands = ''
        mkdir -p ./console/tmp
        mkdir -p ./console/data
        mkdir -p ./console/log
        chmod u+rw ./console
      '';

      config = {
        WorkingDir = "/console";
        Cmd = [
          "${jconsole}/bin/standalone.sh"
        ];
        ExportedPorts = [ 8082 ];
        Env = [
          "JAVA_HOME=${jdk}"
          "JAVA_OPTS=-server -Xms64m -Xmx2048m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=512m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true -Djboss.server.temp.dir=/console/tmp -Djboss.server.data.dir=/console/data -Djboss.server.log.dir=/console/log -Djboss.bind.address=0.0.0.0"
        ];
      };
    };
in
{
  josso-console-img = build {
    version = consoleVersion.version;
    update = consoleVersion.update;
    jconsole = console.josso-console;
  };
}

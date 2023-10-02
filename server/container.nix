{
  pkgs,
  server,
  jdk,
  ...
}: let
in {
  josso-ee-26-img = pkgs.dockerTools.buildImage {
    name = "atricore/josso-ee";
    tag = "2.6.2-1";

    copyToRoot = pkgs.buildEnv {
      name = "root-image";
      paths = [jdk pkgs.bashInteractive pkgs.gnugrep pkgs.procps pkgs.coreutils];
      pathsToLink = ["/bin"];
    };

    # Create needed folders and default config
    extraCommands = ''
      mkdir -p ./server/data/log
      mkdir -p ./server/system
      cp -r ${server.josso-ee-26}/etc ./server/
      chmod -R u+w ./server
      cp -r ${server.josso-ee-26}/etc/container/* ./server/etc/
    '';

    config = {
      WorkingDir = "${server.josso-ee-26}/bin";
      Cmd = [
        "${server.josso-ee-26}/bin/dstart"
      ];
      ExportedPorts = [8081];
      Env = [
        "JAVA_HOME=${jdk}"
        "KARAF_BASE=/server"
        "KARAF_DATA=/server/data"
      ];
    };
  };
}

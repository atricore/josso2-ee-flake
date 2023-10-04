{
  pkgs,
  server,
  jdk,
  ...
}: {
  josso-ee-26-img = pkgs.dockerTools.buildImage {
    name = "atricore/josso-ee";
    tag = "2.6.2-1";

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
      cp -r ${server.josso-ee-26}/etc ./server/
      chmod -R u+w ./server
      cp -r ${server.josso-ee-26}/etc/container/* ./server/etc/
    '';

    config = {
      WorkingDir = "/server";
      Cmd = [
        "${server.josso-ee-26}/bin/dstart"
      ];
      ExportedPorts = [8081];
      Env = [
        "JAVA_HOME=${jdk}"
        "KARAF_HOME=${server.josso-ee-26}"
        "KARAF_BASE=/server"
        "KARAF_DATA=/server/data"
      ];
    };
  };
}

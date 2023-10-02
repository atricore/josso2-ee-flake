{
  stdenv,
  lib,
  jdk,
  system,
}: let
  build = {
    jversion,
    jupdate,
    jsha,
  }:
    stdenv.mkDerivation {
      pname = "josso-ee";
      version = "${jversion}-${jupdate}";

      src = fetchTarball {
        url = "file:///wa/josso/josso2-ee/${jversion}/distributions/josso-ee/target/josso-ee-${jversion}-SNAPSHOT-server-unix.tar.gz";
        #url = "http://downloads.atricore.com/eap/josso-ee-${jversion}-SNAPSHOT-server-unix.tar.gz";
        sha256 = "${jsha}";
      };

      buildInputs = [jdk];

      installPhase = ''
        cp -r "$src/server" "$out"
        chmod u+x "$out/bin/atricore"
        chmod u+x "$out/bin/start"
        chmod u+x "$out/bin/stop"
      '';

      # TODO : Configuration options: port, extensions, followRedirects, cfg folder ?

      meta = with lib; {
        homepage = "https://josso.atricore.com/";
        description = "Simplified Identity and access management";
        sourceProvenance = with sourceTypes; [binaryBytecode];
        inherit (jdk.meta) platforms;
        mainteiners = [
          {
            email = "info@atricore.com";
            github = "atricore";
            githubId = 6369847;
            name = "Atricore, Inc.";
          }
        ];
      };
    };
in {
  josso-ee-26 = build {
    jversion = "2.6.2";
    jupdate = "1";
    jsha = "0nv65za31zwfgw0zqcgsa3xvirzpyhkgzc97c46h8nvdm7sdr1yh";
  };
}

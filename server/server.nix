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
        url = "file:///wa/josso/josso2-ee/${jversion}/distributions/josso-ee/target/josso-ee-${jversion}-SNAPSHOT-server-unix.tar.gz?invalidateCache=6";
        #url = "http://downloads.atricore.com/eap/josso-ee-${jversion}-SNAPSHOT-server-unix.tar.gz";
        sha256 = "${jsha}";
      };

      buildInputs = [jdk];

      installPhase = ''
        cp -r "$src/server" "$out"
        chmod u+x "$out/bin/atricore"
        chmod u+x "$out/bin/start"
        chmod u+x "$out/bin/stop"
        chmod u+x "$out/bin/dstart"
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
    #jsha = "0z54wj4lcq1cg12pvr5s4sfcfsw26kk4y272hapcdi3bi24sx5sp";
    #jsha = "188x4wadd8q7n774qp8ck3yyd5y8npb3nsqf3bpp5chm2q3n0f8l";
    jsha = "0qfcrs4cg0mw0fgd90l458ws9qmhllkqvnwm4bmv32grlpcm6njy";
  };
}

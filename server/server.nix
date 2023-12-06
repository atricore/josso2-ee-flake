{
  stdenv,
  lib,
  jdk,
  ...
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
        url = "file:///wa/josso/josso-ee-flake/tmp/josso-ee-${jversion}-${jupdate}-server.tar.gz?invalidateCache=1";
        #url = "http://downloads.atricore.com/eap/josso-ee-${jversion}-${jupdate}-server.tar.gz";
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

      # Configuration options: port, extensions, followRedirects, cfg folder ?

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
  josso-ee = build {
    jversion = "2.6.2";
    jupdate = "unstable";
    #jsha = "04xnzmq3h3n1gqmgxgx4v1rpx1bnr1g2h7733vz0qsyzqanfxwf1";
    jsha = "";
  };
}

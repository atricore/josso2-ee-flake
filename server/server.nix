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
        url = "file:///wa/iam/josso/josso2-ee-flake/tmp/josso-ee-${jversion}-${jupdate}-server.tar.gz?invalidateCache=3";
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
    jversion = "2.6.3";
    jupdate = "unstable";
    #jsha = "1fz0d90k6qrn8x5aw826746af6pc0n9v03423z6q0dsp86qqxqpa";
    jsha = "0b9kxyrna2778dv2975iyxyma4790ygxgcznhxsi46jl0gbb3zjm";
  };
}

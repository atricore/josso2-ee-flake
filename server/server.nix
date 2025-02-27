{
  stdenv,
  lib,
  jdk,
  jossoVersion,
  ...
}: let
  build = { version, update, sha256 }:
    stdenv.mkDerivation {
      pname = "josso-ee";
      version = "${version}-${update}";

      src = fetchTarball {
        url = "file:///wa/iam/josso/josso2-ee-flake/tmp/josso-ee-${version}-${update}-server.tar.gz?invalidateCache=1";
        #url = "http://downloads.atricore.com/eap/josso-ee-${version}-${update}-server.tar.gz";
        sha256 = "${sha256}";
      };

      buildInputs = [jdk];

      installPhase = ''
        cp -r "$src/server" "$out"
        chmod u+x "$out/bin/atricore"
        chmod u+x "$out/bin/start"
        chmod u+x "$out/bin/stop"
        chmod u+x "$out/bin/dstart"
        chmod u+x "$out/bin/config"
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
  josso-ee = build jossoVersion;
}

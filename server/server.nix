{
  stdenv,
  lib,
  jdk,
  jossoVersion,
  ...
}: let
  build = { version, update,  sha256, filePath, ... }:
    stdenv.mkDerivation {
      pname = "josso-ee";
      version = "${version}-${update}";

      src = fetchTarball {
        url = filePath;
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

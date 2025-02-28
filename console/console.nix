{
  stdenv,
  lib,
  jdk,
  consoleVersion,
  ...
}: let
  build = {version, update, sha256, filePath, ... }:
    stdenv.mkDerivation {
      pname = "josso-console";
      version = "${version}-${update}";

      src = fetchTarball {
        url = filePath;
        #url = "http://downloads.atricore.com/eap/josso-console-${jversion}-${jupdate}-console-unix.tar.gz";
        sha256 = "${sha256}";
      };

      buildInputs = [jdk];

      installPhase = ''
        cp -r "$src/console" "$out"
        chmod u+x "$out/bin/standalone.sh"
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
  josso-console = build consoleVersion ;
}

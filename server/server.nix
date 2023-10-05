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
        #url = "file:///wa/josso/josso2-ee/${jversion}/distributions/josso-ee/target/josso-ee-${jversion}-SNAPSHOT-server-unix.tar.gz?invalidateCache=10";
        url = "http://downloads.atricore.com/eap/josso-ee-${jversion}-${jupdate}-server.tar.gz";
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
  josso-ee = build {
    jversion = "2.6.2";
    jupdate = "2";
    #jsha = "0r43ffasqvvvqy45fvx9g4q3pkbggpdizcsd3q5i3nv82j8jzwnl";
    jsha = "1r8fhs1jiscgs61sy0jz2011mzw72p0zfv1g6nz6g283hjq8vxrj";
  };
}

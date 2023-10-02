{
  pkgs,
  server,
  ...
}: let
in {
  josso-ee-26-img = pkgs.dockerTools.buildImage {
    name = "josso-ee-26";
    tag = "latest";
    config = {
      Cmd = ["${server.josso-ee-26}/bin/atricore"];
    };
  };
}

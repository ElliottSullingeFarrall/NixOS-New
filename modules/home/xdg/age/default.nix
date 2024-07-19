{ config
, lib
, ...
}:

let
  cfg = config.xdg;
  inherit (cfg) enable;
in
{
  config = lib.mkIf enable {
    age = {
      secretsDir = "${config.xdg.dataHome}/agenix";
      secretsMountPoint = "${config.xdg.dataHome}/agenix.d";
    };
  };
}

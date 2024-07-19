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
    home.sessionVariables = {
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    };
  };
}

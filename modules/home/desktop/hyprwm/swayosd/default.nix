{ config
, lib
, ...
}:

let
  cfg = config.desktop.hyprwm;
  inherit (cfg) enable;
in
{
  config = lib.mkIf enable {
    services.swayosd.enable = true;
  };
}

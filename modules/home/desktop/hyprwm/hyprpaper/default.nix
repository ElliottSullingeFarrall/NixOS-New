{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.desktop.hyprwm;
  inherit (cfg) enable;
in
{
  config = lib.mkIf enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;

        preload = [ "${./wallpaper.jpg}" ];
        wallpaper = [ ",${./wallpaper.jpg}" ];
      };
    };
  };
}

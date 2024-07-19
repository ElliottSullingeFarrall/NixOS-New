{ config
, lib
, ...
}:

let
  cfg = config.xdg;
  enable = cfg.enable && config.gtk.enable;
in
{
  config = lib.mkIf enable {
    gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
}

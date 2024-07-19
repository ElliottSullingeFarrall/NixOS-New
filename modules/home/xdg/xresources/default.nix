{ osConfig
, config
, lib
, ...
}:

let
  cfg = config.xdg;
  enable = cfg.enable && osConfig.services.xserver.enable;
in
{
  config = lib.mkIf enable {
    xresources.path = "${config.xdg.configHome}/X11/xresources";
  };
}

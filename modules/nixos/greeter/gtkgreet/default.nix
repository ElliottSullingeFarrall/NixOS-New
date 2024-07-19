{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.greeter;
  enable = cfg == "gtkgreet";
in
{
  config = lib.mkIf enable {
    home-manager.users.greeter = {
      wayland.windowManager.hyprland.settings.exec-once = [
        "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; hyprctl dispatch exit"
      ];
    };
  };
}

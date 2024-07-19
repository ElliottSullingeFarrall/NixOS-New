{ lib
, ...
}:

let
  width = "2256";
  height = "1504";

  refresh = "60";

  scale = "1.333333";
in
{
  boot.loader.grub.gfxmodeEfi = "${width}x${height}";

  home-manager.sharedModules = lib.singleton {
    wayland.windowManager.hyprland.settings.monitor = [
      "eDP-1, ${width}x${height}@${refresh}, auto, ${scale}"
      ", preferred, auto, auto"
    ];
  };
}

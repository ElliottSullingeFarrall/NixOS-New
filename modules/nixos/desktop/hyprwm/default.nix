{ config
, lib
, ...
}:

let
  cfg = config.desktop.hyprwm;
  inherit (cfg) enable;
in
{
  options = {
    desktop.hyprwm.enable = lib.mkEnableOption "hyprwm desktop";
  };

  config = lib.mkIf enable {
    environment.etc."greetd/environments".text = lib.mkIf config.services.greetd.enable (lib.mkBefore "hyprwm");
  };
}

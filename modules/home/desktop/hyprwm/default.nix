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
  options = {
    desktop.hyprwm.enable = lib.mkEnableOption "hyprwm desktop";
  };

  config = lib.mkIf enable {
    home.packages = [
      (pkgs.writeShellScriptBin "hyprwm" "${pkgs.hyprland}/bin/Hyprland > /dev/null 2>&1")
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
      configPackages = with pkgs; [ hyprland ];
    };
  };
}

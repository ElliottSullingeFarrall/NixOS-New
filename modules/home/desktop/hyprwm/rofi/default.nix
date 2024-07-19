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
    home.packages = with pkgs; [
      rofi-power-menu
      rofi-bluetooth

      internal.rofi-mixer
      internal.rofi-wifi-menu
      internal.rofi-network-manager
    ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs.rofi-plugins; [
        rofi-logout
      ];
      terminal = lib.mkIf (builtins.hasAttr "TERMINAL" config.home.sessionVariables) config.home.sessionVariables.TERMINAL;

      cycle = true;
      extraConfig = {
        sidebar-mode = true;
        modes = [ "drun" "window" ];
        display-drun = " 󰵆  Apps ";
        display-run = "   Run ";
        display-window = "   Window";
        # display-Network = " 󰤨  Network";

        dpi = 120;
        show-icons = true;
        icon-theme = "Papirus-Dark";
        drun-display-format = "{name}";

        hover-select = true;
        click-to-exit = true; # Broken
        steal-focus = true;
      };
    };

    xdg.desktopEntries."rofi" = {
      name = "Rofi";
      icon = "rofi";
      noDisplay = true;

      exec = "rofi -show";
      type = "Application";
      terminal = false;
    };
    xdg.desktopEntries."rofi-theme-selector" = {
      name = "Rofi Theme Selector";
      icon = "rofi";
      noDisplay = true;

      exec = "rofi-theme-selector";
      type = "Application";
      terminal = false;
    };
  };
}

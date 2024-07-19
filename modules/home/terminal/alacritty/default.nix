{ config
, lib
, ...
}:

let
  cfg = config.terminal.alacritty;
  enable = cfg.enable || config.terminal.default == "alacritty";
in
{
  options = {
    terminal.alacritty.enable = lib.mkEnableOption "Alacritty terminal emulator";
  };

  config = lib.mkIf enable {
    programs.alacritty.enable = true;

    xdg.desktopEntries."Alacritty" = {
      name = "Alacritty";
      genericName = "Terminal";
      comment = "A fast, cross-platform, OpenGL terminal emulator";
      icon = "Alacritty";
      noDisplay = false;

      exec = "alacritty";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "System" "TerminalEmulator" ];

      actions = {
        New = {
          name = "New Terminal";
          exec = "alacritty";
        };
      };
    };

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "alacritty" = "󰆍";
    };
  };
}

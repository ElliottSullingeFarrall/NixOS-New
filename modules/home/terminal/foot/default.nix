{ config
, lib
, ...
}:

let
  cfg = config.terminal.foot;
  enable = cfg.enable || config.terminal.default == "foot";
in
{
  options = {
    terminal.foot.enable = lib.mkEnableOption "Foot terminal emulator";
  };

  config = lib.mkIf enable {
    programs.foot.enable = true;

    xdg.desktopEntries."org.codeberg.dnkl.foot" = {
      name = "Foot";
      genericName = "Terminal";
      comment = "A wayland native terminal emulator";
      icon = "foot";
      noDisplay = false;

      exec = "foot";
      terminal = false;
      type = "Application";

      categories = [ "System" "TerminalEmulator" ];
    };
    xdg.desktopEntries."org.codeberg.dnkl.footclient" = {
      name = "Foot Client";
      genericName = "Terminal Emulator";
      comment = "A wayland native terminal emulator (client)";
      icon = "foot";
      noDisplay = true;

      exec = "footclient";
      type = "Application";
      terminal = false;

      categories = [ "System" "TerminalEmulator" ];
    };
    xdg.desktopEntries."org.codeberg.dnkl.foot-server" = {
      name = "Foot Server";
      genericName = "Terminal Emulator";
      comment = "A wayland native terminal emulator (server)";
      icon = "foot";
      noDisplay = true;

      exec = "foot --server";
      type = "Application";
      terminal = false;

      categories = [ "System" "TerminalEmulator" ];
    };

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "foot" = "󰆍";
      "footclient" = "󰆍";
    };
  };
}

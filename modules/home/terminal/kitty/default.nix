{ config
, lib
, ...
}:

let
  cfg = config.terminal.kitty;
  enable = cfg.enable || config.terminal.default == "kitty";
in
{
  options = {
    terminal.kitty.enable = lib.mkEnableOption "Kitty terminal emulator";
  };

  config = lib.mkIf enable {
    programs.kitty = {
      enable = true;

      settings = {
        confirm_os_window_close = 0;
      };
    };

    xdg.desktopEntries."kitty" = {
      name = "Kitty";
      genericName = "Terminal Emulator";
      comment = "Fast, feature-rich, GPU based terminal";
      icon = "kitty";
      noDisplay = false;

      exec = "kitty";
      type = "Application";
      startupNotify = true;

      categories = [ "System" "TerminalEmulator" ];
    };
    xdg.desktopEntries."kitty-open" = {
      name = "Kitty URL Launcher";
      genericName = "Terminal Emulator";
      comment = "Open URLs with kitty";
      icon = "kitty";
      noDisplay = true;

      exec = "kitty +open %U";
      type = "Application";
      startupNotify = true;

      categories = [ "System" "TerminalEmulator" ];
      mimeType = [ "image/*" "application/x-sh" "application/x-shellscript" "inode/directory" "text/*" "x-scheme-handler/kitty" "x-scheme-handler/ssh" ];
    };

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "kitty" = "󰆍";
    };
  };
}

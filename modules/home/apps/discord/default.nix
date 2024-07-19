{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.discord;
  inherit (cfg) enable;
in
{
  options = {
    apps.discord.enable = lib.mkEnableOption "Install Discord.";
  };

  config = pkgs.lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      discord
      vesktop
    ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."discord" = {
      name = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      icon = "discord";
      noDisplay = true;

      exec = "Discord";
      type = "Application";
      terminal = false;

      categories = [ "Network" "InstantMessaging" ];
      mimeType = [ "x-scheme-handler/discord" ];
    };

    xdg.desktopEntries."vesktop" = {
      name = "Discord";
      genericName = "Internet Messenger";
      icon = "discord";
      noDisplay = false;

      exec = "vesktop %U";
      type = "Application";
      terminal = false;

      categories = [ "Network" "InstantMessaging" "Chat" ];
    };

    /* -------------------------------------------------------------------------- */
    /*                                Configuration                               */
    /* -------------------------------------------------------------------------- */

    xdg.configFile."vesktop/settings/settings.json" = {
      text = ''
        {
          "themeLinks": [
            "https://catppuccin.github.io/discord/dist/catppuccin-macchiato-pink.theme.css"
          ]
        }
      '';
      force = true;
    };

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "discord" = "󰙯";
    };
  };
}

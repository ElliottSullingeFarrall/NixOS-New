{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.obsidian;
  inherit (cfg) enable;
in
{
  options = {
    apps.obsidian.enable = lib.mkEnableOption "Install Obsidian.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      obsidian
    ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."obsidian" = {
      name = "Obsidian";
      comment = "Knowledge base";
      icon = "obsidian";
      noDisplay = false;

      exec = "obsidian %u";
      type = "Application";

      categories = [ "Office" ];
      mimeType = [ "x-scheme-handler/obsidian" ];
    };

    /* -------------------------------------------------------------------------- */
    /*                                  Defaults                                  */
    /* -------------------------------------------------------------------------- */

    xdg.mimeApps.defaultApplications = {
      "text/markdown" = "obsidian.desktop";
    };

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "obsidian" = "";
    };
  };
}

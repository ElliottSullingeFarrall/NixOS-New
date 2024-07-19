{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.nemo;
  inherit (cfg) enable;
in
{
  options = {
    apps.nemo.enable = lib.mkEnableOption "Install Nemo file manager.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs.cinnamon; [
      nemo-with-extensions
      nemo-fileroller
    ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."nemo" = {
      name = "Files";
      comment = "Access and organize files";
      icon = "system-file-manager";
      noDisplay = false;

      exec = "nemo %U";
      type = "Application";
      terminal = false;
      startupNotify = false;

      categories = [ "GNOME" "GTK" "Utility" "Core" ];
      mimeType = [ "inode/directory" "application/x-gnome-saved-search" ];

      actions = {
        "open-home" = {
          name = "Home";
          exec = "nemo %U";
        };
        "open-computer" = {
          name = "Computer";
          exec = "nemo computer:///";
        };
        "open-trash" = {
          name = "Trash";
          exec = "nemo trash:///";
        };
      };
    };

    # xdg.desktopEntries."nemo-autostart" = {
    #   name = "Nemo";
    #   comment = "Start Nemo desktop at log in";
    #   noDisplay = true;

    #   exec = "nemo-desktop";
    #   type = "Application";
    # };

    # xdg.desktopEntries."nemo-autorun-software" = {
    #   name = "Autorun Prompt";
    #   noDisplay = true;

    #   exec = "nemo-autorun-software %u";
    #   type = "Application";
    #   terminal = false;
    #   startupNotify = false;

    #   mimeType = [ "x-content/unix-software" ];
    # };

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "nemo" = "󰪶";
    };
  };
}

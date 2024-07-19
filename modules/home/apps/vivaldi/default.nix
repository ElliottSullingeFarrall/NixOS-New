{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.vivaldi;
  inherit (cfg) enable;
in
{
  options = {
    apps.vivaldi.enable = lib.mkEnableOption "Install Vivaldi.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      vivaldi
    ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."vivaldi-stable" = {
      name = "Vivaldi";
      genericName = "Web Browser";
      comment = "Access the Internet";
      icon = "vivaldi";
      noDisplay = false;

      exec = "vivaldi %U";
      type = "Application";
      terminal = false;
      startupNotify = true;

      categories = [ "Network" "WebBrowser" ];
      mimeType = [ "application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/ftp" "x-scheme-handler/http" "x-scheme-handler/https" "x-scheme-handler/mailto" ];

      actions = {
        "new-window" = {
          name = "New Window";
          exec = "vivaldi --new-window";
        };
        "new-private-window" = {
          name = "New Private Window";
          exec = "vivaldi --incognito";
        };
      };
    };

    /* -------------------------------------------------------------------------- */
    /*                                  Defaults                                  */
    /* -------------------------------------------------------------------------- */

    xdg.mimeApps.defaultApplications = {
      "text/html" = "vivaldi.desktop";
      "application/pdf" = "vivaldi.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
    } // (builtins.listToAttrs (map (type: { name = "image/${type}"; value = "vivaldi-stable.desktop"; }) [
      "jpeg"
      "png"
      "svg"
      "gif"
      "webp"
    ])) // (builtins.listToAttrs (map (type: { name = "image/${type}"; value = "vivaldi-stable.desktop"; }) [
      "mp4"
      "mpeg"
      "webm"
    ]));

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    wayland.windowManager.hyprland.settings.windowrule = lib.mkIf config.wayland.windowManager.hyprland.enable [
      "tile, ^(Vivaldi-stable)$"
    ];

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "vivaldi" = "󰖟";
    };
  };
}

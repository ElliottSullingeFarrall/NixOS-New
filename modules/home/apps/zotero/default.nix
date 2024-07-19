{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.zotero;
  inherit (cfg) enable;

  id = "tvqk3odd";
in
{
  options = {
    apps.zotero.enable = lib.mkEnableOption "Install Zotero.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      zotero_7
    ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."zotero" = {
      name = "Zotero";
      genericName = "Reference Management";
      comment = "Collect, organize, cite, and share your research sources";
      icon = "zotero";
      noDisplay = false;

      exec = "zotero -url %U";
      type = "Application";
      startupNotify = true;

      categories = [ "Office" "Database" ];
      mimeType = [ "x-scheme-handler/zotero" "text/plain" ];
    };

    /* -------------------------------------------------------------------------- */
    /*                                Configuration                               */
    /* -------------------------------------------------------------------------- */

    xdg.configFile."zotero/profiles.ini" = {
      text = ''
        [General]
        StartWithLastProfile=1

        [Profile0]
        Name=default
        IsRelative=1
        Path=${id}.default
        Default=1
      '';
      force = true;
    };

    xdg.configFile."zotero/${id}.default/user.js" = {
      text = ''
        user_pref("extensions.zotero.dataDir", "${config.xdg.dataHome}/zotero");
      '';
    };

    home.activation = {
      linkZotero = lib.internal.mkLinkScript' "${config.xdg.configHome}" "${config.home.homeDirectory}/.zotero";
      linkMozilla = lib.internal.mkLinkScript "${config.xdg.dataHome}/mozilla" "${config.home.homeDirectory}/.mozilla";
    };

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    wayland.windowManager.hyprland.settings.windowrulev2 = lib.mkIf config.wayland.windowManager.hyprland.enable [
      "float, class:(Zotero), title:(Progress)"
    ];

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "zotero" = "󰰸";
    };
  };
}

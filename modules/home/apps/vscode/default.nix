{ config
, lib
, ...
}:

let
  cfg = config.apps.vscode;
  inherit (cfg) enable;
in
{
  options = {
    apps.vscode.enable = lib.mkEnableOption "Install Visual Studio Code.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    programs.vscode = {
      enable = true;
    };

    home.shellAliases = {
      code-compat = "ELECTRON_OZONE_PLATFORM_HINT= code";
    };

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."code" = {
      name = "VS Code";
      genericName = "Text Editor";
      comment = "Code editing. Redefined.";
      icon = "vscode";
      noDisplay = false;

      exec = "code %F";
      type = "Application";
      startupNotify = true;

      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      mimeType = [ "text/plain" "inode/directory" ];

      actions = {
        "new-empty-window" = {
          name = "New Empty Window";
          icon = "vscode";
          exec = "code --new-window %F";
        };
      };
    };

    xdg.desktopEntries."code-url-handler" = {
      name = "VS Code URL Handler";
      genericName = "Text Editor";
      comment = "Code editing. Redefined.";
      icon = "vscode";
      noDisplay = true;

      exec = "code --open-url %U";
      type = "Application";
      startupNotify = true;

      categories = [ "Utility" "TextEditor" "Development" "IDE" ];
      mimeType = [ "x-scheme-handler/vscode" ];
    };

    # xdg.desktopEntries."code-insiders" = {
    #   name = "VS Code";
    #   genericName = "Text Editor";
    #   comment = "Code editing. Redefined.";
    #   icon = "vscode-insiders";
    #   noDisplay = false;

    #   exec = "boxxy code-insiders %F";
    #   type = "Application";
    #   startupNotify = true;

    #   categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    #   mimeType = [ "text/plain" "inode/directory" ];

    #   actions = {
    #     "new-empty-window" = {
    #       name = "New Empty Window";
    #       icon = "vscode-insiders";
    #       exec = "boxxy code-insiders --new-window %F";
    #     };
    #   };
    # };

    # xdg.desktopEntries."code-insiders-url-handler" = {
    #   name = "VS Code URL Handler";
    #   genericName = "Text Editor";
    #   comment = "Code editing. Redefined.";
    #   icon = "vscode-insiders";
    #   noDisplay = true;

    #   exec = "boxxy code-insiders --open-url %U";
    #   type = "Application";
    #   startupNotify = true;

    #   categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    #   mimeType = [ "x-scheme-handler/vscode-insiders" ];
    # };

    /* -------------------------------------------------------------------------- */
    /*                                Configuration                               */
    /* -------------------------------------------------------------------------- */

    home.activation = {
      linkVscode = lib.internal.mkLinkScript "${config.xdg.dataHome}/vscode" "${config.home.homeDirectory}/.vscode";
      linkVscodeInsiders = lib.internal.mkLinkScript "${config.xdg.dataHome}/vscode-insiders" "${config.home.homeDirectory}/.vscode-insiders";
      linkPki = lib.internal.mkLinkScript "${config.xdg.dataHome}/pki" "${config.home.homeDirectory}/.pki";
    };

    /* -------------------------------------------------------------------------- */
    /*                                  Defaults                                  */
    /* -------------------------------------------------------------------------- */

    xdg.mimeApps.defaultApplications = (builtins.listToAttrs (map (type: { name = type; value = "code.desktop"; }) [
      "text/plain"
      "text/html"
      "text/css"
      "text/javascript"
      "application/javascript"
      "application/json"
      "application/xml"
      "application/x-yaml"
      "application/x-python"
      "application/x-php"
      "application/x-ruby"
      "application/x-perl"
      "application/x-shellscript"
      "application/x-csrc"
      "application/x-c++src"
      "application/x-java"
      "application/sql"
    ])) // {
      "application/x-desktop" = "code-url-handler.desktop";
    };

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "code" = "󰨞";
      "code-insiders" = "󰨞";
    };
  };
}

{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.mathematica;
  inherit (cfg) enable;
in
{
  options = {
    apps.mathematica.enable = lib.mkEnableOption "Install Mathematica.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      mathematica
    ];

    /* -------------------------------------------------------------------------- */
    /*                                    Alias                                   */
    /* -------------------------------------------------------------------------- */

    home.shellAliases = {
      Mathematica = "MATHEMATICA_USERBASE=${config.xdg.configHome}/Mathematica Mathematica";
    };

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."com.wolfram.Mathematica.14.0" = {
      name = "Mathematica";
      comment = "Technical Computing System";
      icon = "wolfram-mathematica";
      noDisplay = false;

      exec = "env MATHEMATICA_USERBASE=${config.xdg.configHome}/Mathematica ${pkgs.mathematica}/libexec/Mathematica/Executables/Mathematica --name com.wolfram.Mathematica.14.0 %F";
      type = "Application";

      mimeType = [ "application/mathematica" "application/x-mathematica" "application/vnd.wolfram.nb" "application/vnd.wolfram.cdf" "application/vnd.wolfram.player" "application/vnd.wolfram.mathematica.package" "application/vnd.wolfram.wl" "x-scheme-handler/wolfram+cloudobject" "x-scheme-handler/wolframmathematica+cloudobject" ];
    };

    /* -------------------------------------------------------------------------- */
    /*                                Configuration                               */
    /* -------------------------------------------------------------------------- */

    home.sessionVariables = {
      MATHEMATICA_USERBASE = "${config.xdg.configHome}/Mathematica";
    };

    xdg.configFile."Mathematica/Kernel/init.m" = {
      text = ''
        With[{dir = $UserDocumentsDirectory <> "/Wolfram Mathematica"},
          If[DirectoryQ[dir], DeleteDirectory[dir]]
        ]
      '';
      force = true;
    };

    xdg.configFile."Mathematica/FrontEnd/init.m" = {
      text = ''
        SetOptions[$FrontEnd,
          VersionsLaunched->{"14.0.0"},

          NotebookBrowseDirectory -> "${config.xdg.configHome}/Mathematica/SystemFiles/FrontEnd/StyleSheets",
          DefaultStyleDefinitions -> "${config.xdg.configHome}/Mathematica/SystemFiles/FrontEnd/StyleSheets/Catppuccin.nb",

          WindowToolbars -> {},
          ShowPredictiveInterface -> False,

          NotebookAutoSave -> True,
          ClosingAutoSave -> True,

          PrivateFrontEndOptions -> {ShowAtStartup -> NewDocument},
          PrivateNotebookOptions -> {FinalWindowPrompt -> False}
        ]
      '';
      force = true;
    };

    home.activation = {
      linkWolfram = lib.internal.mkLinkScript "${config.xdg.dataHome}/Wolfram" "${config.home.homeDirectory}/.Wolfram";
    };

    /* -------------------------------------------------------------------------- */
    /*                                 Integration                                */
    /* -------------------------------------------------------------------------- */

    wayland.windowManager.hyprland.settings.windowrule = lib.mkIf config.wayland.windowManager.hyprland.enable [
      "float, title:^(Mathematica)$"
    ];

    programs.waybar.settings.mainBar."hyprland/workspaces".window-rewrite = lib.mkIf config.programs.waybar.enable {
      "mathematica" = "󰪚";
    };
  };
}

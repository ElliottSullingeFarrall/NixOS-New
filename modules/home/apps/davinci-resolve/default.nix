{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.davinci-resolve;
  inherit (cfg) enable;
in
{
  options = {
    apps.davinci-resolve.enable = lib.mkEnableOption "Install DaVinci Resolve.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      davinci-resolve
    ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."davinci-resolve" = {
      name = "DaVinci Resolve";
      genericName = "Video Editor";
      comment = "Professional video editing, color, effects and audio post-processing";
      icon = "davinci-resolve";

      exec = "davinci-resolve";
      type = "Application";

      categories = [ "AudioVideo" "AudioVideoEditing" "Video" "Graphics" ];
    };
  };
}

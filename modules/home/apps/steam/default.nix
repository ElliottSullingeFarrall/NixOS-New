{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.steam;
  inherit (cfg) enable;
in
{
  options = {
    apps.steam.enable = lib.mkEnableOption "Install Steam.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [
      steam
    ];
  };
}

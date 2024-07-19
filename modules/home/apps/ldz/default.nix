{ inputs
, system
, config
, lib
, ...
}:

let
  cfg = config.apps.ldz;
  inherit (cfg) enable;
in
{
  options = {
    apps.ldz.enable = lib.mkEnableOption "Install LDZ.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with inputs.ldz-apps.packages.${system}; [
      ldz
    ];
  };
}

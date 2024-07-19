{ osConfig
, config
, lib
, ...
}:

let
  cfg = config.xdg;
  enable = cfg.enable && osConfig.programs.adb.enable;
in
{
  config = lib.mkIf enable {
    home.sessionVariables = {
      ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    };

    home.shellAliases = {
      adb = "HOME=${config.xdg.dataHome}/android adb";
    };
  };
}

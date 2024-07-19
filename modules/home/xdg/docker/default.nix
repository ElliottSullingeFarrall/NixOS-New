{ osConfig
, config
, lib
, ...
}:

let
  cfg = config.xdg;
  enable = cfg.enable && osConfig.virtualisation.docker.enable;
in
{
  config = lib.mkIf enable {
    home.sessionVariables = {
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    };
  };
}

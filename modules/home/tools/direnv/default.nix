{ config
, lib
, ...
}:

let
  cfg = config.tools.direnv;
  inherit (cfg) enable;
in
{
  options = {
    tools.direnv.enable = lib.mkEnableOption "direnv";
  };

  config = lib.mkIf enable {
    programs.direnv = {
      enable = true;
      silent = true;
      config = {
        global.warn_timeout = 0;
      };
      nix-direnv.enable = true;
    };
  };
}

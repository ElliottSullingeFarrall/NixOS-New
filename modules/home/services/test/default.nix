{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.test;
  inherit (cfg) enable;
in
{
  options = {
    services.test.enable = lib.mkEnableOption "test service";
  };

  config = lib.mkIf enable {
    systemd.user.services.test = {
      Unit = {
        Description = "Test service";
      };
      Service = {
        ExecStart = "${pkgs.coreutils}/bin/test";
      };
    };
  };
}

{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.locker;
  enable = cfg == "gtklock";
in
{
  config = lib.mkIf enable {
    environment.systemPackages = with pkgs; [ gtklock ];
    security.pam.services.gtklock = { };

    services.systemd-lock-handler.enable = true;
    systemd.user.services.systemd-lock-handler-gtklock = {
      unitConfig = {
        Description = "Screen locker for Wayland";
        OnSuccess = "unlock.target";
        PartOf = "lock.target";
        After = "lock.target";
      };
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.gtklock}/bin/gtklock -d";
        Restart = "on-failure";
        RestartSec = 0;
      };
      wantedBy = [ "lock.target" ];
    };
  };
}

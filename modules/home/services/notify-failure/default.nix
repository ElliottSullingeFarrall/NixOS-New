{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.systemd-notifications;
  inherit (cfg) enable;

  state_system = "/var/tmp/systemd_system_state.json";
  state_user = "/var/tmp/systemd_user_state.json";
in
{
  options = {
    services.systemd-notifications.enable = lib.mkEnableOption "notifications for failed services";
  };

  config = lib.mkIf enable {
    systemd.user.services.systemd-notifications = {
      Unit = {
        Description = "Check systemd service statuses and notify on changes";
      };
      Service = {
        Type = "simple";
        ExecStartPre = [
          "${pkgs.coreutils}/bin/rm -f ${state_system}"
          "${pkgs.coreutils}/bin/rm -f ${state_user}"
          "${pkgs.coreutils}/bin/touch ${state_system}"
          "${pkgs.coreutils}/bin/touch ${state_user}"
        ];
        ExecStart = pkgs.writeShellScript "systemd-notifications" /*sh*/''
          init_system() {
            systemd_state=$(systemctl --system --output=json)

            echo "$systemd_state" | ${pkgs.jq}/bin/jq -c '.[]' | while read -r service; do
              unit=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.unit')
              curr_state=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.active')

              if [[ "$curr_state" == "failed" ]]; then
                ${pkgs.libnotify}/bin/notify-send "Service Failed" "$unit has failed."
              fi
            done

            echo "$systemd_state" | ${pkgs.jq}/bin/jq > "${state_system}"
          }
          init_user() {
            systemd_state=$(systemctl --user --output=json)

            echo "$systemd_state" | ${pkgs.jq}/bin/jq -c '.[]' | while read -r service; do
              unit=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.unit')
              curr_state=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.active')

              if [[ "$curr_state" == "failed" ]]; then
                ${pkgs.libnotify}/bin/notify-send "Service Failed" "$unit has failed."
              fi
            done

            echo "$systemd_state" | ${pkgs.jq}/bin/jq > "${state_user}"
          }

          check_system() {
            systemd_state=$(systemctl --system --output=json)

            echo "$systemd_state" | ${pkgs.jq}/bin/jq -c '.[]' | while read -r service; do
              unit=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.unit')
              curr_state=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.active')
              prev_state=$(${pkgs.jq}/bin/jq -r --arg unit "$unit" '.[] | select(.unit==$unit) | .active' "${state_system}")

              if [[ "$prev_state" != "$curr_state" ]]; then
                if [[ "$curr_state" == "active" ]]; then
                  ${pkgs.libnotify}/bin/notify-send "Service Started" "$unit has started successfully."
                elif [[ "$curr_state" == "failed" ]]; then
                  ${pkgs.libnotify}/bin/notify-send "Service Failed" "$unit has failed."
                fi
              fi

              echo "$systemd_state" | ${pkgs.jq}/bin/jq > "${state_system}"
            done
          }
          check_user() {
            systemd_state=$(systemctl --user --output=json)

            echo "$systemd_state" | ${pkgs.jq}/bin/jq -c '.[]' | while read -r service; do
              unit=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.unit')
              curr_state=$(echo "$service" | ${pkgs.jq}/bin/jq -r '.active')
              prev_state=$(${pkgs.jq}/bin/jq -r --arg unit "$unit" '.[] | select(.unit==$unit) | .active' "${state_user}")

              if [[ "$prev_state" != "$curr_state" ]]; then
                if [[ "$curr_state" == "active" ]]; then
                  ${pkgs.libnotify}/bin/notify-send "Service Started" "$unit has started successfully."
                elif [[ "$curr_state" == "failed" ]]; then
                  ${pkgs.libnotify}/bin/notify-send "Service Failed" "$unit has failed."
                fi
              fi

              echo "$systemd_state" | ${pkgs.jq}/bin/jq > "${state_user}"
            done
          }

          init_system
          init_user

          while true; do
            sleep 10
            check_system
            check_user
          done
        '';
        ExecStop = [
          "${pkgs.coreutils}/bin/rm ${state_system}"
          "${pkgs.coreutils}/bin/rm ${state_user}"
        ];
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}

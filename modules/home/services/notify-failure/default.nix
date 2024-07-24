{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.services.notify-failure;
  inherit (cfg) enable;
in
{
  options = {
    services.notify-failure.enable = lib.mkEnableOption "notifications for failed services";
  };

  config = lib.mkIf enable {
    systemd.user.services.notify-failure = {
      Unit = {
        Description = "Check systemd service statuses and notify on changes";
      };
      Service = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/touch /var/tmp/systemd_user_state.json";
        ExecStart = pkgs.writeShellScript "notify-failure" /*sh*/''
          state_file="/var/tmp/systemd_user_state.json"

          init() {
            systemd_state=$(systemctl --user --type=service --state=failed,active --output=json)

            echo "$systemd_state" | ${pkgs.jq}/bin/jq -c '.[]' | while read -r unit; do
                service=$(echo "$unit" | ${pkgs.jq}/bin/jq -r '.unit')
                curr_state=$(echo "$unit" | ${pkgs.jq}/bin/jq -r '.active')

                if [[ "$curr_state" == "failed" ]]; then
                  ${pkgs.libnotify}/bin/notify-send "Service Failed" "$service has failed."
                fi
              done

            echo "$systemd_state" | ${pkgs.jq}/bin/jq . > "$state_file"
          }

          check() {
            while true; do
              systemd_state=$(systemctl --user --type=service --state=failed,active --output=json)

              echo "$systemd_state" | ${pkgs.jq}/bin/jq -c '.[]' | while read -r unit; do
                service=$(echo "$unit" | ${pkgs.jq}/bin/jq -r '.unit')
                curr_state=$(echo "$unit" | ${pkgs.jq}/bin/jq -r '.active')
                prev_state=$(${pkgs.coreutils}/bin/cat "$state_file" | ${pkgs.jq}/bin/jq -r "(map(select(.unit == \"$service\")) | .[0].active)")

                if [[ "$prev_state" != "$curr_state" ]]; then
                  if [[ "$curr_state" == "active" ]]; then
                    ${pkgs.libnotify}/bin/notify-send "Service Started" "$service has started successfully."
                  elif [[ "$curr_state" == "failed" ]]; then
                    ${pkgs.libnotify}/bin/notify-send "Service Failed" "$service has failed."
                  fi
                fi
              done

              echo "$systemd_state" | ${pkgs.jq}/bin/jq . > "$state_file"
            done
          }

          # Run initial pass and then start monitoring
          init
          sleep 10
          while true; do
            check
            sleep 10
          done
        '';
        ExecStop = "${pkgs.coreutils}/bin/rm /var/tmp/systemd_user_state.json";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}

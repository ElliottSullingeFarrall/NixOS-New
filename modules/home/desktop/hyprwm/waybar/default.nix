{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.desktop.hyprwm;
  inherit (cfg) enable;
in
{
  config = lib.mkIf enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      style = /*css*/''
        * {
          font-family: Ubuntu Nerd Font;
          font-size: 14px;
        }

        #waybar {
          background: transparent;
        }

        tooltip {
          background: @surface0;
        }
        tooltip label {
          color: @text;
        }

        #menu,
        #status,
        #system,
        #clock,
        #custom-media,
        #workspaces {
          margin: 0;

          color: @pink;
          border-radius: 1rem;
          background-color: @surface0;
        }

        #clock,
        #custom-media {
          padding: 0 0.5rem;
        }

        #custom-media {
          margin-left: 0.5rem;

          font-family: UbuntuMono Nerd Font;
        }

        #status,
        #system {
          margin-right: 0.5rem;
        }

        #custom-notification,
        #battery.status,
        #network.status,
        #bluetooth.status,
        #pulseaudio.status,
        #backlight.status,
        #custom-button.system,
        #temperature.system,
        #cpu.system,
        #memory.system,
        #disk.system,
        #network.system,
        #idle_inhibitor,
        #custom-power,
        #custom-reboot,
        #custom-logout,
        #custom-lock,
        #workspaces button {
          padding: 0 0.5rem;

          border-radius: 1rem;
        }
        #custom-notification:hover,
        #battery.status:hover,
        #network.status:hover,
        #bluetooth.status:hover,
        #pulseaudio.status:hover,
        #backlight.status:hover,
        #custom-button.system:hover,
        #temperature.system:hover,
        #cpu.system:hover,
        #memory.system:hover,
        #disk.system:hover,
        #network.system:hover,
        #idle_inhibitor:hover,
        #custom-power:hover,
        #custom-reboot:hover,
        #custom-logout:hover,
        #custom-lock:hover,
        #workspaces button:hover {
          background-color: @surface1;
        }

        #custom-notification {
          color: @pink;
        }

        #battery.status {
          color: @green;
        }
        #battery.status.charging {
          color: @green;
        }
        #battery.status.warning:not(.charging) {
          color: @yellow;
        }
        #battery.status.critical:not(.charging) {
          color: @red;
        }

        #network.status {
          margin-right: 0.5rem;

          color: @sky;
        }

        #bluetooth.status {
          margin-right: 0.5rem;

          color: @blue;
        }

        #pulseaudio.status {
          margin-right: 0.5rem;

          color: @maroon;
        }

        #backlight.status {
          margin-right: 0.5rem;

          color: @yellow;
        }

        #custom-button.system {
          color: @pink;
        }

        #temperature.system {
          margin-right: 0.5rem;

          color: @red;
        }

        #cpu.system {
          margin-right: 0.5rem;

          color: @sapphire;
        }

        #memory.system {
          margin-right: 0.5rem;

          color: @mauve;
        }

        #disk.system {
          margin-right: 0.5rem;

          color: @green;
        }

        #network.system {
          margin-right: 0.5rem;

          color: @peach;
        }

        #workspaces button {
          color: @text;
        }
        #workspaces button.empty {
          color: @overlay0;
        }
        #workspaces button.active {
          color: @pink;
        }
      '';

      settings.mainBar = {
        mode = "dock";
        layer = "top";

        margin-top = 5;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "hyprland/workspaces" "custom/media" ];
        modules-center = [ "clock" ];
        modules-right = [ "group/system" "group/status" "group/menu" ];

        "group/menu" = {
          orientation = "inherit";
          modules = [
            "group/logout"
            # "systemd-failed-units"
            "custom/notification"
          ];
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            "none" = "󰂜";
            "dnd-none" = "󰪑";
            "inhibited-none" = "󰪑";
            "dnd-inhibited-none" = "󰪑";

            "notification" = "󰂚";
            "dnd-notification" = "󰂛";
            "inhibited-notification" = "󰂛";
            "dnd-inhibited-notification" = "󰂛";
          };
          exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          return-type = "json";
          escape = true;
        };

        "systemd-failed-units" = {
          format = "󰒏 {nr_failed}";
          on-click = "${config.home.sessionVariables.TERMINAL} sh -c ${pkgs.writeShellScript "status" ''
            trap ' ' INT TERM EXIT
            watch -t '\
              echo "System Units"; \
              systemctl --system --failed --output json | ${pkgs.internal.jtbl}/bin/jtbl -t; \
              echo "User Units"; \
              systemctl --user   --failed --output json | ${pkgs.internal.jtbl}/bin/jtbl -t \
            '
          ''}";
          on-click-right = "${pkgs.writeShellScript "restart" ''
            systemctl --system --failed --output json | ${pkgs.jq}/bin/jq -r '.[].unit' | ${pkgs.findutils}/bin/xargs -r systemctl --system restart
            systemctl --user   --failed --output json | ${pkgs.jq}/bin/jq -r '.[].unit' | ${pkgs.findutils}/bin/xargs -r systemctl --user restart
            systemctl --user restart waybar.service # TODO: Must be a better way to do this
          ''}";
        };

        "group/logout" = {
          orientation = "inherit";
          modules = [
            "custom/lock"
            "idle_inhibitor"
            "custom/power"
            "custom/reboot"
            "custom/logout"
          ];
          drawer = {
            "transition-left-to-right" = false;
          };
        };

        "custom/power" = {
          format = "󰐥";
          exec = ''
            printf '{"tooltip": "Shutdown"}'
          '';
          return-type = "json";
          on-click = "systemctl poweroff";
        };

        "custom/reboot" = {
          format = "󰜉";
          exec = ''
            printf '{"tooltip": "Reboot"}'
          '';
          return-type = "json";
          on-click = "systemctl reboot";
        };

        "custom/logout" = {
          format = "󰍃";
          exec = ''
            printf '{"tooltip": "Logout"}'
          '';
          return-type = "json";
          on-click = "loginctl terminate-user $USER";
        };

        "custom/lock" = {
          format = "󰌾";
          exec = ''
            printf '{"tooltip": "Lock"}'
          '';
          return-type = "json";
          on-click = "loginctl lock-session";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            "activated" = "󰷛";
            "deactivated" = "󰍹";
          };
          tooltip-format-activated = "Idle Inhibitor (Activated)";
          tooltip-format-deactivated = "Idle Inhibitor (Deactivated)";
        };

        "group/status" = {
          orientation = "inherit";
          modules = [
            "backlight#status"
            "pulseaudio#status"
            "bluetooth#status"
            "network#status"
            "battery#status"
          ];
        };

        "battery#status" = {
          format = "{icon}";
          format-icons = {
            "default" = [ "󱃍" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            "charging" = [ "󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
            "plugged" = "󰚥";
          };
          states = {
            "warning" = 30;
            "critical" = 10;
          };
          tooltip-format-discharging = "Battery ({capacity}%)";
          tooltip-format-charging = "Charging ({capacity}%)";
          tooltip-format-not-charging = "Not Charging ({capacity}%)";
          tooltip-format-plugged = "Plugged In ({capacity}%)";
          on-click = "${config.programs.rofi.finalPackage}/bin/rofi -show power-menu -modi 'power-menu:rofi-power-menu --choices=lockscreen/logout/reboot/shutdown'";
        };

        "network#status" = {
          format = "{icon}";
          format-icons = {
            "default" = "󰤫";
            "disconnected" = "󰤮";
            "wifi" = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
            "ethernet" = "󰌗";
          };
          tooltip-format-disconnected = "Disconnected";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{essid} (Ethernet)";
          on-click = "${pkgs.internal.rofi-wifi-menu}/bin/rofi-wifi-menu";
        };

        "bluetooth#status" = {
          format = "{icon}";
          format-icons = {
            "disabled" = "󰀦";
            "connected" = "󰂰";
            "on" = "󰂯";
            "off" = "󰂲";
          };
          tooltip-format-disabled = "Bluetooth (Disabled)";
          tooltip-format-connected = "{device_alias} ({device_battery_percentage}%)";
          tooltip-format-on = "Bluetooth (On)";
          tooltip-format-off = "Bluetooth (Off)";
          on-click = "${pkgs.rofi-bluetooth}/bin/rofi-bluetooth";
        };

        "pulseaudio#status" = {
          format = "{icon}";
          format-bluetooth = "{icon}<sup></sup>";
          format-muted = "󰝟";
          format-icons = {
            "default" = [ "󰕿" "󰖀" "󰕾" ];
            "headphone" = "󰋋";
            "hifi" = "󰓃";
            "hdmi" = "󰽟";
            "hands-free" = "󰋎";
            "headset" = "󰋎";
            "phone" = "";
            "portable" = "󰐺";
            "car" = "󰄋";
          };
          tooltip-format = "{desc} ({volume}%)";
          on-click = "${pkgs.internal.rofi-mixer}/bin/rofi-mixer";
        };

        "backlight#status" = {
          format = "{icon}";
          format-icons = [ "󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠" ];
          tooltip-format = "Brightness ({percent}%)";
          device = "intel_backlight";
        };

        "group/system" = {
          orientation = "inherit";
          modules = [
            "custom/button#system"
            "temperature#system"
            "cpu#system"
            "memory#system"
            "disk#system"
            "network#system"
          ];
          drawer = {
            "transition-left-to-right" = false;
          };
        };

        "custom/button#system" = {
          format = "󰄨";
          tooltip = false;
        };

        "temperature#system" = {
          thermal-zone = 1;
          format = "󰔏 {temperatureC}°C";
          tooltip-format = "Temperature ({temperatureC}°C)";
        };

        "cpu#system" = {
          format = "󰘚 {avg_frequency}GHz";
        };

        "memory#system" = {
          format = "󰍛 {used}GiB";
          tooltip-format = "RAM ({percentage}%)";
        };

        "disk#system" = {
          format = "󱛟 {used}";
          tooltip-format = "Disk ({percentage_used}%)";
        };

        "network#system" = {
          format = "󰛳 {bandwidthUpBits} | {bandwidthDownBits}";
          tooltip-format = "Network (Up: {bandwidthUpBytes} Down: {bandwidthDownBytes})";
        };

        "clock" = {
          format = "{:%H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            format = {
              months = "<span font='UbuntuMono Nerd Font' color='#cad3f5'><b>{}</b></span>";
              weeks = "<span font='UbuntuMono Nerd Font' color='#cad3f5'>{}</span>";
              days = "<span font='UbuntuMono Nerd Font' color='#cad3f5'>{}</span>";
              weekdays = "<span font='UbuntuMono Nerd Font' color='#a5adcb'>{}</span>";
              today = "<span font='UbuntuMono Nerd Font' color='#f5bde6'><b>{}</b></span>";
            };
          };
          actions = {
            "on-click" = "shift_down";
            "on-click-right" = "shift_up";
          };
        };

        "custom/media" = {
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
          exec = "${pkgs.writeShellScript "music_panel" ''
            # Inspired by:
            # https://github.com/Alexays/Waybar/discussions/2006

            CURRENT_SONG="${pkgs.writeShellScript "current_song" ''
              PLAYER_STATUS=$(${pkgs.playerctl}/bin/playerctl -s status | tail -n1)
              ARTIST=$(${pkgs.playerctl}/bin/playerctl metadata artist | sed 's/&/+/g')
              TITLE=$(${pkgs.playerctl}/bin/playerctl metadata title | sed 's/&/+/g')

              if [[ $PLAYER_STATUS == "Paused" || $PLAYER_STATUS == "Playing" ]]; then
                echo "$ARTIST - $TITLE"
              elif [[ $PLAYER_STATUS == "Stopped" ]]; then
                echo
              else
                exit 1
              fi
            ''}"

            ${pkgs.zscroll}/bin/zscroll \
              --delay 0.15 \
              --length 30 \
              --match-command "${pkgs.playerctl}/bin/playerctl status" \
              --scroll-padding " | " \
              --match-text "Playing" "--before-text '󰐊 ' --scroll 1" \
              --match-text "Paused" "--before-text '󰏤 ' --scroll 0" \
              --match-text "Stopped" "" \
              --update-interval 1 \
              --update-check true \
              $CURRENT_SONG
            wait
        ''}";
        };

        "hyprland/workspaces" = {
          format = "{icon} | {windows}";
          window-rewrite-default = "󰏗";
        };
      };
    };
  };
}

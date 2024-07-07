{ config
, lib
, pkgs
, inputs
, ...
}:

let
  cfg = config.greeter.gtkgreet;
  enable = cfg.enable;
in
{
  options = {
    greeter.gtkgreet.enable = lib.mkEnableOption "gtkgreet greeter";
  };

  config = lib.mkIf enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = "greeter";
          command = "hyprwm";
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      hyprwm
    '';

    users.users.greeter = {
      isSystemUser = lib.mkForce false;
      isNormalUser = true;
    };
    home-manager.users.greeter = {
      imports = with inputs; [
        catnerd.homeModules.catnerd
      ];
      inherit (config) catnerd;

      home = {
        inherit (config.system) stateVersion;

        packages = [
          (pkgs.writeShellScriptBin "hyprwm" "${pkgs.hyprland}/bin/Hyprland > /dev/null 2>&1")
        ];
      };

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          exec-once = [
            "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; hyprctl dispatch exit"
          ];
          input = {
            kb_layout = "gb";
          };
          misc = {
            disable_hyprland_logo = true;
          };
        };
      };

      gtk.enable = true;
    };
  };
}
{ config
, lib
, pkgs
, inputs
, ...
}:

let
  enable = builtins.hasAttr "greeter" config;
in
{
  options = {
    greeter = lib.mkOption {
      type = lib.types.enum [
        "gtkgreet"
      ];
      description = "The greeter to use.";
    };
  };

  config = lib.mkIf enable {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.hyprland}/bin/Hyprland > /dev/null 2>&1";
    };

    users.users.greeter = {
      isSystemUser = lib.mkForce false;
      isNormalUser = lib.mkForce true;
    };
    home-manager.users.greeter = {
      imports = with inputs; [
        catnerd.homeModules.catnerd
      ];
      inherit (config) catnerd;

      wayland.windowManager.hyprland = {
        enable = true;
        settings.misc.disable_hyprland_logo = true;
      };
      gtk.enable = true;
    };
  };
}

{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.terminal;
  inherit (cfg) default;
in
{
  options = {
    terminal.default = lib.mkOption {
      type = lib.types.enum [
        "alacritty"
        "foot"
        "kitty"
        "wezterm"
      ];
      default = "kitty";
      description = "The default terminal emulator to use.";
    };
  };

  config = {
    home.sessionVariables.TERMINAL = "${pkgs.${default}}.bin.${default}";
  };
}

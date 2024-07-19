{ config
, lib
, ...
}:

let
  cfg = config.shell;
  inherit (cfg) default;
in
{
  options = {
    shell.default = lib.mkOption {
      type = lib.types.enum [
        "bash"
        "zsh"
      ];
      default = "bash";
      description = "The default shell to use.";
    };
  };
}

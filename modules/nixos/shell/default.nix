{ config
, lib
, pkgs
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

  config = lib.mkIf (default != "bash") {
    users.defaultUserShell = pkgs.${default};
  };
}

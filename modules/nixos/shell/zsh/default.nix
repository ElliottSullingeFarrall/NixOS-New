{ config
, lib
, ...
}:

let
  cfg = config.shell.zsh;
  enable = cfg.enable || config.shell.default == "zsh";
in
{
  options = {
    shell.zsh.enable = lib.mkEnableOption "zsh shell";
  };

  config = lib.mkIf enable {
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ]; # Allows completion for system packages

    environment.etc."greetd/environments".text = lib.mkIf config.services.greetd.enable "zsh";
  };
}

{ config
, ...
}:

{
  config = {
    programs.bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
    };
  };
}

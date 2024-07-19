{ osConfig
, config
, lib
, ...
}:

let
  cfg = config.xdg;
  enable = cfg.enable && osConfig.services.printing.enable;
in
{
  config = lib.mkIf enable {
    xdg.desktopEntries = {
      "cups" = {
        name = "Manage Printing";
        comment = "CUPS Web Interface";
        icon = "cups";
        noDisplay = true;

        exec = "xdg-open http://localhost:631";
        type = "Application";
        terminal = false;
        startupNotify = false;

        categories = [ "System" "Printing" "HardwareSettings" "X-Red-Hat-Base" ];
      };
    };
  };
}

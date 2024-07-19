{ config
, lib
, ...
}:

let
  cfg = config.home-manager;
  enable = cfg.useUserPackages;
in
{
  config = lib.mkIf enable {
    # https://github.com/nix-community/home-manager/pull/5158#issuecomment-2043764620
    environment.pathsToLink = [ "/share/xdg-desktop-portal" ];
  };
}

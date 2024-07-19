{ config
, lib
, ...
}:

let
  stateVersion = config.version.nixos;
in
{
  options = {
    version.nixos = lib.mkOption {
      type = lib.types.str;
      default = config.system.nixos.release;
      description = ''
        The version of NixOS to use.
      '';
    };
  };

  config = {
    system = {
      inherit stateVersion;
    };
    home-manager.sharedModules = lib.lists.singleton {
      home = {
        inherit stateVersion;
      };
    };
  };
}

{ config
, lib
, pkgs
, ...
}:

let
  version = config.version.nix;
in
{
  options = {
    version.nix = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The version of Nix to use.
      '';
    };
  };

  config = {
    nix.package =
      if version == "" then
        pkgs.nix
      else if version == "git" then
        pkgs.nixVersions.git
      else if version == "latest" then
        pkgs.nixVersions.latest
      else if version == "minimum" then
        pkgs.nixVersions.minimum
      else
        pkgs.nixVersions."nix_${builtins.replaceStrings ["."] ["_"] version}";
  };
}

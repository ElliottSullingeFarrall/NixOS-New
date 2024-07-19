{ config
, lib
, pkgs
, ...
}:

let
  version = config.version.linux;
in
{
  options = {
    version.linux = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The version of Linux to use.
      '';
    };
  };

  config = {
    boot.kernelPackages =
      if version == "" then
        pkgs.linuxPackages
      else if version == "latest" then
        pkgs.linuxPackages_latest
      else
        pkgs.linuxKernel.packages."linux_${builtins.replaceStrings ["."] ["_"] version}";
  };
}

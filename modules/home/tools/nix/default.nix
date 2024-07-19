{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.tools.nix;
  inherit (cfg) enable;
in
{
  options = {
    tools.nix.enable = lib.mkEnableOption "Nix tools";
  };

  config = lib.mkIf enable {
    home.packages = with pkgs; [
      nixd
      nixpkgs-fmt
    ];

    programs.nix-index.enable = true;
    programs.nix-index-database.comma.enable = true;
  };
}

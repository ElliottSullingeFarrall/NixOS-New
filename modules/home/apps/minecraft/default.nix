{ config
, lib
, pkgs
, ...
}:

let
  cfg = config.apps.minecraft;
  inherit (cfg) enable;
in
{
  options = {
    apps.minecraft.enable = lib.mkEnableOption "Install Minecraft.";
  };

  config = lib.mkIf enable {
    /* -------------------------------------------------------------------------- */
    /*                                  Packages                                  */
    /* -------------------------------------------------------------------------- */

    home.packages = with pkgs; [ prismlauncher ];

    /* -------------------------------------------------------------------------- */
    /*                                   Desktop                                  */
    /* -------------------------------------------------------------------------- */

    xdg.desktopEntries."org.prismlauncher.PrismLauncher" = {
      name = "Minecraft";
      comment = "A custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft at once.";
      icon = "${pkgs.minecraft.overrideAttrs(_: _: { meta.broken = false; })}/share/icons/hicolor/symbolic/apps/minecraft-launcher.svg";
      noDisplay = false;

      exec = " ${pkgs.prismlauncher}/bin/prismlauncher %U";
      type = "Application";
      terminal = false;

      categories = [ "Game" "ActionGame" "AdventureGame" "Simulation" ];
      mimeType = [ "application/zip" "application/x-modrinth-modpack+zip" "x-scheme-handler/curseforge" ];
    };

    /* -------------------------------------------------------------------------- */
    /*                                Configuration                               */
    /* -------------------------------------------------------------------------- */

    home.activation = {
      linkJava = lib.internal.mkLinkScript "${config.xdg.configHome}/java" "${config.home.homeDirectory}/.java";
      linkMinecraft = lib.internal.mkLinkScript "${config.xdg.dataHome}/minecraft" "${config.home.homeDirectory}/.minecraft";
      linkMputils = lib.internal.mkLinkScript "${config.xdg.dataHome}/mputils" "${config.home.homeDirectory}/.mputils";
    };
  };
}

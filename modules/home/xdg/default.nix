{ config
, lib
, ...
}:

let
  cfg = config.xdg;
  inherit (cfg) enable;
in
{
  config = lib.mkIf enable {
    xdg = {
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";

      userDirs = {
        enable = true;
        createDirectories = true;

        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        publicShare = "${config.home.homeDirectory}/Public";
        templates = "${config.home.homeDirectory}/Templates";
        videos = "${config.home.homeDirectory}/Videos";

        extraConfig = {
          XDG_REPO_DIR = "${config.home.homeDirectory}/Repositories";
          XDG_REMOTE_DIR = "${config.home.homeDirectory}/Remotes";
        };
      };

      mime.enable = true;
      mimeApps.enable = true;
    };

    home.activation.linkDesktopEntries = lib.home-manager.hm.dag.entryAfter [ "writeBoundary" "createXdgUserDirectories" ] ''
      if [ ! -d ${config.xdg.dataHome}/applications ]; then
        run mkdir -p ${config.xdg.dataHome}/applications
      fi

      run rm -f ${config.xdg.dataHome}/applications/*.desktop

      for file in /etc/profiles/per-user/elliott/share/applications/*.desktop; do
        link=${config.xdg.dataHome}/applications/$(basename "$file")
        run ln -s "$file" "$link"
      done
    '';
  };
}

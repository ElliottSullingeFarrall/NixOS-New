{ config
, lib
, pkgs
, ...
}:

let
  mounts = [ "Work" "OneDrive" "Google" "DropBox" ];
in
{
  home.packages = with pkgs; [
    rclone
  ];

  age.secrets = {
    id-Work = {
      file = ./id-Work.age;
      path = "${config.xdg.configHome}/rclone/id-Work";
      substitutions = [ "${config.xdg.configHome}/rclone/rclone.conf" ];
    };
    id-OneDrive = {
      file = ./id-OneDrive.age;
      path = "${config.xdg.configHome}/rclone/id-OneDrive";
      substitutions = [ "${config.xdg.configHome}/rclone/rclone.conf" ];
    };
    token-Work = {
      file = ./token-Work.age;
      path = "${config.xdg.configHome}/rclone/token-Work";
      substitutions = [ "${config.xdg.configHome}/rclone/rclone.conf" ];
    };
    token-OneDrive = {
      file = ./token-OneDrive.age;
      path = "${config.xdg.configHome}/rclone/token-OneDrive";
      substitutions = [ "${config.xdg.configHome}/rclone/rclone.conf" ];
    };
    token-Google = {
      file = ./token-Google.age;
      path = "${config.xdg.configHome}/rclone/token-Google";
      substitutions = [ "${config.xdg.configHome}/rclone/rclone.conf" ];
    };
    token-DropBox = {
      file = ./token-DropBox.age;
      path = "${config.xdg.configHome}/rclone/token-DropBox";
      substitutions = [ "${config.xdg.configHome}/rclone/rclone.conf" ];
    };
  };

  xdg.configFile."rclone/rclone.conf" = {
    text = /*toml*/''
      [Work]
      type = onedrive
      token = @token-Work@
      drive_id = @id-Work@
      drive_type = business

      [OneDrive]
      type = onedrive
      token = @token-OneDrive@
      drive_id = @id-OneDrive@
      drive_type = personal

      [Google]
      type = drive
      token = @token-Google@
      team_drive =

      [DropBox]
      type = dropbox
      token = @token-DropBox@
    '';
    force = true;
  };

  systemd.user.services = builtins.listToAttrs (map
    (remote: {
      name = lib.internal.mkMountName "${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
      value = {
        Unit = {
          Description = "Mount for ${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          Type = "notify";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
          ExecStart = "${pkgs.rclone}/bin/rclone mount ${remote}: ${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote} --allow-other --file-perms 0777 --vfs-cache-mode writes";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u ${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
          Restart = "on-failure";
          RestartSec = "10s";
          Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
    mounts);

  # Unmount not working for FUSE without sudo
  # systemd.user.mounts = builtins.listToAttrs (map
  #   (remote: {
  #     name = lib.internal.mkMountName "${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
  #     value = {
  #       Unit = {
  #         Description = "Mount for ${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
  #         After = [ "network-online.target" ];
  #       };
  #       Mount = {
  #         Type = "fuse.rclonefs";
  #         What = "${remote}:";
  #         Where = "${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
  #         Options = lib.concatStringsSep "," [ "allow_other" "file_perms=0777" "vfs-cache-mode=writes" ];
  #         ExecSearchPath = "${pkgs.rclone}/bin/:/run/wrappers/bin/";
  #       };
  #       Install = {
  #         # Since we are not using automount
  #         WantedBy = [ "default.target" ];
  #       };
  #     };
  #   })
  #   mounts);

  # Automount units not working as user units
  # systemd.user.automounts = builtins.listToAttrs (map
  #   (remote: {
  #     name = lib.internal.mkMountName "${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
  #     value = {
  #       Unit = {
  #         Description = "Automount for ${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
  #         After = [ "network-online.target" ];
  #         Before = [ "remote-fs.target" ];
  #       };
  #       Automount = {
  #         Where = "${config.xdg.userDirs.extraConfig.XDG_REMOTE_DIR}/${remote}";
  #         TimeoutIdleSec = 600;
  #       };
  #       Install = {
  #         WantedBy = [ "multi-user.target" ];
  #       };
  #     };
  #   }) mounts);
}

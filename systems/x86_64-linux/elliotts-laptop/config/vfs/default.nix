{ ...
}:

{
  # Enable gvfs for trash and recents support in file managers
  services.gvfs.enable = true;

  # Enables --allow-other in rclone mount
  programs.fuse.userAllowOther = true;
}

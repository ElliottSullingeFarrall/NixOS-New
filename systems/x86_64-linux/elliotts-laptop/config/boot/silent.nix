{ ...
}:

{
  boot = {
    # Hide stage 1 messages
    initrd.verbose = false;

    # Hide initrd and systemd-udevd messages
    kernelParams = [ "quiet" "udev.log_level=3" ];
  };
}

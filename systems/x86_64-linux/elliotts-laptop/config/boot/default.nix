{ ...
}:

{
  imports = [
    ./efi.nix
    ./silent.nix
  ];

  boot = {
    kernelParams = [
      "boot.shell_on_fail" # Allows for root shell if failure to boot. Requires root password.
    ];

    loader = {
      grub = {
        enable = true;
        device = "nodev";
      };
      timeout = 3;
    };

    plymouth.enable = true;
  };
}

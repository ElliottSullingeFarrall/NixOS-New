{ ...
}:

{
  # EFI Support
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub.efiSupport = true;
  };
}

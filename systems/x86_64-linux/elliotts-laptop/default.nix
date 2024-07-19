{ config
, ...
}:

{
  imports = [
    ./config
    ./hardware-configuration.nix
  ];

  /* --------------------------------- Version -------------------------------- */

  version = {
    linux = "latest";
    nix = "latest";
    nixos = "24.11";
  };

  /* ------------------------------ Home Manager ------------------------------ */

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "old";
  };

  /* ---------------------------------- Shell --------------------------------- */

  shell = {
    default = "zsh";
    zsh.enable = true;
  };

  /* --------------------------------- Greeter -------------------------------- */

  greeter = "gtkgreet";

  /* --------------------------------- Locker --------------------------------- */

  locker = "gtklock";

  /* --------------------------------- Dekstop -------------------------------- */

  desktop = {
    hyprwm.enable = true;
  };

  /* ---------------------------------- Users --------------------------------- */

  age.secrets = {
    password-elliott = {
      file = ./password-elliott.age;
    };
  };
  users.users = {
    elliott = {
      isNormalUser = true;
      uid = 1000;
      hashedPasswordFile = config.age.secrets.password-elliott.path;
      extraGroups = [ "networkmanager" "wheel" "docker" "openrazer" "adbusers" ];
    };
  };
}

{ host
, ...
}:

{
  networking = {
    hostName = host;
    networkmanager.enable = true;
  };

  services.openssh.enable = true;
}

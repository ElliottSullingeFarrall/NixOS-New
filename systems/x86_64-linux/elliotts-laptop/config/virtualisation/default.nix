{ pkgs
, ...
}:

{
  environment.systemPackages = with pkgs; [
    quickemu
  ];

  virtualisation = {
    docker.enable = true;

    spiceUSBRedirection.enable = true;
  };
}

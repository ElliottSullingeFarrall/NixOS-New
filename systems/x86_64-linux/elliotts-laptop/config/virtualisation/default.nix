{ pkgs
, ...
}:

{
  environment.systemPackages = with pkgs; [
    kubectl
    talosctl
    quickemu
  ];

  virtualisation = {
    docker.enable = true;

    spiceUSBRedirection.enable = true;
  };
}

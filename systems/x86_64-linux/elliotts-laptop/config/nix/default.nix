{ ...
}:

{
  documentation.nixos.enable = false;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      min-free = "${toString (50 * 1024 * 1024 * 1024)}";
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  programs.nh = {
    enable = true;
    # clean.enable = true;
  };
}

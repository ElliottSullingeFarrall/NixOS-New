{ lib
, ...
}:

lib.pre-commit-hooks.x86_64-linux.run {
  src = ./.;

  hooks = {
    # Nix
    nil.enable = true;
    nixpkgs-fmt.enable = true;
    deadnix.enable = false;
    statix.enable = true;
    # Shell
    shfmt.enable = true;
    # TOML
    check-toml.enable = true;
    # taplo.enable = true;
    # Misc
    check-added-large-files = {
      enable = true;
      excludes = [ "\\wallpaper.jpg" ];
    };
    check-executables-have-shebangs.enable = true;
    check-shebang-scripts-are-executable.enable = true;
    detect-private-keys.enable = true;
    editorconfig-checker.enable = true;
    end-of-file-fixer.enable = true;
    trim-trailing-whitespace.enable = true;
  };
}

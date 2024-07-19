{ mkShell
, inputs
, pkgs
, ...
}:

mkShell {
  name = "nixos";

  inherit (inputs.self.checks.x86_64-linux.pre-commit) shellHook;
  buildInputs = inputs.self.checks.x86_64-linux.pre-commit.enabledPackages;

  packages = with pkgs; [
    snowfallorg.flake
    fup-repl
    agenix

    nix-init
    niv

    xdg-ninja
  ];
}

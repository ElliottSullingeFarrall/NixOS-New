{ sources ? import ../../nix/sources.nix
, ...
}:

final: prev:
{
  libtsm = prev.libtsm.overrideAttrs (attrs: {
    version = "${sources.libtsm.branch}-${sources.libtsm.rev}";

    src = final.fetchFromGitHub { inherit (sources.libtsm) owner repo rev sha256; };
  });
}

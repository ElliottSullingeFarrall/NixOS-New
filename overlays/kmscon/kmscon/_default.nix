{ sources ? import ../../nix/sources.nix
, ...
}:

final: prev:
{
  kmscon = prev.kmscon.overrideAttrs (attrs: {
    version = "${sources.kmscon.branch}-${sources.kmscon.rev}";

    src = final.fetchFromGitHub { inherit (sources.kmscon) owner repo rev sha256; };

    buildInputs = attrs.buildInputs ++ (with final; [
      check
    ]);

    patches = [ ./0001-modified-systemdunitdir.patch ];

    mesonFlags = [
      "-Ddocs=disabled"

      "-Dvideo_fbdev=disabled"
      # "-Dvideo_drm2d=enabled"
      # "-Dvideo_drm3d=enabled"

      # "-Drenderer_bbulk=disabled"
      # "-Drenderer_gltex=disabled"
      # "-Drenderer_pixman=enabled"

      # "-Dfont_unifont=disabled"
      # "-Dfont_pango=enabled"
    ];
  });
}

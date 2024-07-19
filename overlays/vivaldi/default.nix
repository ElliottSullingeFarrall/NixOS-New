{ ...
}:

final: prev:
{
  vivaldi = prev.vivaldi.overrideAttrs (attrs: {
    postInstall = (attrs.postInstall or "") + ''
      wrapProgram $out/bin/vivaldi \
        --add-flags "\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}"
    '';
  });
}

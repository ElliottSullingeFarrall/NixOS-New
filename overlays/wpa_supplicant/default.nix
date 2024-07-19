{ ...
}:

final: prev:
{
  wpa_supplicant = prev.wpa_supplicant.overrideAttrs (attrs: {
    patches = attrs.patches ++ [ ./eduroam.patch ];
  });
}

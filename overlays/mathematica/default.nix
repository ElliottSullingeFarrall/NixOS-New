{ ...
}:

final: prev:
{
  mathematica = prev.mathematica.overrideAttrs (attrs: rec {
    name = "mathematica-${version}";
    version = "14.0.0";
    installer = "Mathematica_${version}_LINUX.sh";
    src = prev.requireFile {
      name = installer;
      sha256 = "37332119066aea8e95e1476d271507ff2c8fdacef08d347ce92440ee55bb25f2";
      message = ''
        This nix expression requires that ${installer} is already part of the store.
      '';
    };
  });
}

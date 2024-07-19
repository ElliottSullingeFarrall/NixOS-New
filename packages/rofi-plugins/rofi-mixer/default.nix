{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, python3
, pulseaudio

, sources ? import ../../nix/sources.nix
}:

stdenv.mkDerivation rec {
  pname = "rofi-mixer";
  version = "${sources.${pname}.branch}-${sources.${pname}.rev}";

  src = fetchFromGitHub { inherit (sources.${pname}) owner repo rev sha256; };

  sourceRoot = "${src.name}/src";

  installPhase = ''
    install -Dm755 rofi-mixer.py $out/bin/rofi-mixer.py
    wrapProgram $out/bin/rofi-mixer.py --prefix PATH : ${lib.makeBinPath [ pulseaudio ]}

    install -Dm755 rofi-mixer $out/bin/rofi-mixer
  '';

  buildInputs = [ python3 pulseaudio ];
  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "A sound device mixer made with rofi";
    homepage = "https://github.com/joshpetit/rofi-mixer";
    license = licenses.mit;
    # maintainers = with maintainers; [ ];
    mainProgram = "rofi-mixer";
    platforms = platforms.all;
  };
}

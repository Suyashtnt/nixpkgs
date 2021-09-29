{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, qmake
, pkg-config
, qttools
, qtbase
, rtaudio
, rtmidi
}:

mkDerivation rec {
  pname = "bambootracker";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "BambooTracker";
    repo = "BambooTracker";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1mpbvhsmrn0wdmxfp3n5dwv4474qlhy47r3vwc2jwdslq6vgl1fa";
  };

  nativeBuildInputs = [ qmake qttools pkg-config ];

  buildInputs = [ qtbase rtaudio rtmidi ];

  qmakeFlags = [ "CONFIG+=system_rtaudio" "CONFIG+=system_rtmidi" ];

  postConfigure = "make qmake_all";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/{bin,Applications}/BambooTracker.app
    ln -s $out/{Applications/BambooTracker.app/Contents/MacOS,bin}/BambooTracker
  '';

  meta = with lib; {
    description = "A tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    homepage = "https://bambootracker.github.io/BambooTracker/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}

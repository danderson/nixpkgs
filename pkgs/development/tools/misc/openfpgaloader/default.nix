{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,

  libftdi1,
  libudev,
  libusb,
}:

stdenv.mkDerivation rec {
  pname = "openfpgaloader";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${version}";
    sha256 = "0j87mlghbanh6c7lrxv0x3p6zgd0wrkcs9b8jf6ifh7b3ivcfg82";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libftdi1
    libudev
    libusb
  ];

  meta = with lib; {
    description = "Universal utility for programming FPGAs";
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = licenses.agpl3;
    maintainers = with maintainers; [ danderson ];
  };
}

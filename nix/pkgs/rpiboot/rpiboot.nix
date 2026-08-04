{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
  pkg-config,
}:
stdenv.mkDerivation rec {
  name = "rpiboot";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = "bbd603383eda4d61c54bd466bca59478ba37e167";
    hash = "sha256-FRsiu9aZF5duzHD2dNt58/1NrUE90ISIiXbFuatenIE=";
    fetchSubmodules = true;
  };

  buildInputs = [libusb1];
  nativeBuildInputs = [pkg-config];

  patchPhase = ''
    sed -i "s@/usr/@$out/@g" main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/rpiboot
    cp rpiboot $out/bin
    cp -r msd $out/share/rpiboot
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/usbboot";
    description = "Utility to boot a Raspberry Pi CM/CM3/CM4/Zero over USB";
    mainProgram = "rpiboot";
    license = licenses.asl20;
    maintainers = with maintainers; [cartr flokli];
    platforms = ["aarch64-linux" "aarch64-darwin" "armv7l-linux" "armv6l-linux" "x86_64-linux" "x86_64-darwin"];
  };
}

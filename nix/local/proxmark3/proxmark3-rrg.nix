{ lib,stdenv, fetchFromGitHub, pkg-config, bzip2, lz4, openssl
, buildPackages
, readline
, pkgsx86_64Darwin
, hardwarePlatform ? "PM3RDV4"

, hardwarePlatformExtras ? "" }:

stdenv.mkDerivation rec {
  pname = "proxmark3-rrg";
  version = "4.18589";

  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "proxmark3";
    rev = "v${version}";
    sha256 = "sha256-e/FoyaHU/uH2yovEqtkrCXwHMlF94Acxl2lUA422Pig=";
  };

  nativeBuildInputs = [
    pkg-config
    pkgsx86_64Darwin.gcc-arm-embedded
  ];
  
  buildInputs = [
    bzip2
    lz4
    readline
    openssl
    buildPackages.darwin.apple_sdk.frameworks.Foundation
    buildPackages.darwin.apple_sdk.frameworks.AppKit
  ];

  makeFlags = [
    "PLATFORM=${hardwarePlatform}"
    "PLATFORM_EXTRAS=${hardwarePlatformExtras}"
  ];


  installPhase = ''
    make install PREFIX=$out
  '';

  dontPatchShebangs = true;

  preFixup = ''
    patchShebangs ./bin
  '';

  meta = with lib; {
    description = "Client for proxmark3, powerful general purpose RFID tool";
    homepage = "https://rfidresearchgroup.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nyanotech ];
  };
}

{ lib,stdenv, fetchFromGitHub, pkg-config, bzip2
, buildPackages
, readline
, pkgsx86_64Darwin
, hardwarePlatform ? "PM3RDV4"

, hardwarePlatformExtras ? "" }:

stdenv.mkDerivation rec {
  pname = "proxmark3-rrg";
  version = "4.14831";

  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "proxmark3";
    rev = "v${version}";
    sha256 = "sha256-s0D04V6vlGW7SVkJwzMKaVfXQoT3Wi0lu7RC61Es89A=";
  };

  nativeBuildInputs = [
    pkg-config
    pkgsx86_64Darwin.gcc-arm-embedded
  ];
  
  buildInputs = [
    bzip2
    readline
    buildPackages.darwin.apple_sdk.frameworks.Foundation
    buildPackages.darwin.apple_sdk.frameworks.AppKit
  ];

  preConfigure = "LD=$CC";

  prePatch = ''
    substituteInPlace Makefile.defs --replace 'CC = gcc' 'CC ?= gcc'
    substituteInPlace Makefile.defs --replace 'CXX = g++' 'CC ?= g++'
    substituteInPlace Makefile.defs --replace 'LD = g++' 'CC ?= g++'
  '';

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

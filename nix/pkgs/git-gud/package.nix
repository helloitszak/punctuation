{
  lib,
  stdenv,
  makeWrapper,
  figlet,
  lolcat,
}:
stdenv.mkDerivation rec {
  pname = "gid-gud";
  version = "lol";
  src = ./bin;
  installPhase = ''
    mkdir -p $out/bin
    install git-gud $out/bin
  '';
  nativeBuildInputs = [makeWrapper];
  wrapperPath = lib.makeBinPath [figlet lolcat];
  postFixup = ''
    wrapProgram $out/bin/git-gud --prefix PATH : "${wrapperPath}"
  '';
}

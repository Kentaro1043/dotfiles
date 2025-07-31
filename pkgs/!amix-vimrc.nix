{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "amix-vimrc";
  version = "2024-10-06";

  src = fetchFromGitHub {
    owner = "amix";
    repo = "vimrc";
    rev = "46294d589d15d2e7308cf76c58f2df49bbec31e8";
    sha256 = "sha256-g1appWgZlE27Rm8gorGp9B1c6UvGhg1bESgHk8umJ8g=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "The ultimate Vim configuration (vimrc)";
    homepage = "https://github.com/amix/vimrc";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

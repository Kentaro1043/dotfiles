{
  lib,
  fetchurl,
  stdenv,
}: let
  version = "0.116.0";

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-r6CJwDLDExeSGrwC+4gUU67UqoADWEEhce/NBp7OoeM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-aarch64-apple-darwin.tar.gz";
      hash = "sha256-FIc19fIgmy9qMb18o2icYowubFJo/7oL6T93IPz4kvU=";
    };
  };

  binaries = {
    x86_64-linux = "codex-x86_64-unknown-linux-musl";
    aarch64-darwin = "codex-aarch64-apple-darwin";
  };
in
  stdenv.mkDerivation {
    pname = "codex-bin";
    inherit version;

    src = sources.${stdenv.hostPlatform.system};

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m755 ${binaries.${stdenv.hostPlatform.system}} $out/bin/codex
      runHook postInstall
    '';

    meta = with lib; {
      description = " Lightweight coding agent that runs in your terminal";
      homepage = "https://github.com/openai/codex";
      license = licenses.asl20;
      platforms = ["x86_64-linux" "aarch64-darwin"];
      sourceProvenance = with sourceTypes; [binaryNativeCode];
    };
  }

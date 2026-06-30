{inputs, ...}: {
  additions = final: _prev: import ../pkgs {inherit inputs;} final.pkgs;

  modifications = final: prev: {
    uhd =
      if prev.stdenv.isDarwin
      then
        (import inputs.nixpkgs-fix-uhd {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = false;
        }).uhd
      else prev.uhd;
    dump1090-fa =
      if prev.stdenv.isDarwin
      then
        (import inputs.nixpkgs-fix-dump1090 {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = false;
        }).dump1090-fa
      else prev.dump1090-fa;
    steghide =
      if prev.stdenv.isDarwin
      then
        prev.steghide.overrideAttrs (old: {
          configureFlags = (old.configureFlags or []) ++ ["--disable-nls"];
        })
      else prev.steghide;
    mise = let
      package = inputs.mise.packages.${prev.stdenv.hostPlatform.system}.mise;
    in
      if prev.stdenv.isDarwin
      then
        package.overrideAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              substituteInPlace src/oci/layer.rs \
                --replace-fail \
                  $'    #[test]\n    fn preserve_metadata_dir_layer_keeps_special_permission_bits()' \
                  $'    #[test]\n    #[ignore = "setuid bits are stripped in the Darwin Nix build sandbox"]\n    fn preserve_metadata_dir_layer_keeps_special_permission_bits()'
            '';
        })
      else package;
    wfview = prev.wfview.overrideAttrs (old: {
      NIX_CFLAGS_COMPILE =
        (old.NIX_CFLAGS_COMPILE or "")
        + " -fpermissive";
      postPatch =
        (old.postPatch or "")
        + prev.lib.optionalString prev.stdenv.isDarwin ''
          substituteInPlace cachingqueue.h \
            --replace-fail "bool operator==(const queueItem& lhs)" \
                           "bool operator==(const queueItem& lhs) const"
        '';
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config = final.config;
    };
  };
}

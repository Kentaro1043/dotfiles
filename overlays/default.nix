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
    wfview = prev.wfview.overrideAttrs (old: {
      NIX_CFLAGS_COMPILE =
        (old.NIX_CFLAGS_COMPILE or "")
        + " -fpermissive";
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config = final.config;
    };
  };
}

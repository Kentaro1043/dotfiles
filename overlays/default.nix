{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    uhd =
      if prev.stdenv.isDarwin
      then
        (import inputs.nixpkgs-fix-uhd {
          system = final.system;
          config.allowUnfree = false;
        }).uhd
      else prev.uhd;
    dump1090-fa =
      if prev.stdenv.isDarwin
      then
        (import inputs.nixpkgs-fix-dump1090 {
          system = final.system;
          config.allowUnfree = false;
        }).dump1090-fa
      else prev.dump1090-fa;
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config = final.config;
    };
  };
}

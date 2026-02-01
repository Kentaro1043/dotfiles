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
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config = final.config;
    };
  };
}

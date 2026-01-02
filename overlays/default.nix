{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    uhd =
      (import inputs.nixpkgs-fix-uhd {
        system = final.system;
        config.allowUnfree = true;
      }).uhd;
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  nixpkgs-2505-packages = final: _prev: {
    deprecated = import inputs.nixpkgs-2505 {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}

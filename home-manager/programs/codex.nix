{pkgs,...}: {
  programs.codex = {
    enable = true;
    package = pkgs.unstable.codex;
    settings = {
      model = "gpt-oss:20b-cloud";
      model_provider = "ollama";
      model_providers = {
        ollama = {
          name = "ollama";
          base_url = "http://localhost:11434/v1";
          wire_api = "chat";
        };
      };
    };
  };
}
{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.unstable.opencode;
    settings = {
      theme = "dracula";

      # Model
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            "qwen3-coder:480b-cloud" = {
              name = "qwen3-coder:480b-cloud";
            };
            "deepseek-v3.1:671b-cloud" = {
              name = "deepseek-v3.1:671b-cloud";
            };
            "gpt-oss:20b-cloud" = {
              name = "gpt-oss:20b-cloud";
            };
            "gpt-oss:120b-cloud" = {
              name = "gpt-oss:120b-cloud";
            };
            "qwen3-coder-next:cloud" = {
              name = "qwen3-coder-next:cloud";
            };
          };
        };
      };
    };
    themes = {
      dracula = ./opencode-dracula.json;
    };
    enableMcpIntegration = true;
  };
}

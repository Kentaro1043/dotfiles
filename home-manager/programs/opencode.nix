{
  config,
  llmAgentPackages,
  ...
}: {
  sops.secrets.litellm-api-key = {};

  programs.opencode = {
    enable = true;
    package = llmAgentPackages.opencode;
    tui = {
      theme = "dracula";
    };
    settings = {
      provider = {
        litellm = {
          npm = "@ai-sdk/openai-compatible";
          name = "LiteLLM";
          options = {
            baseURL = "https://litellm.internal.kentaro1043.com/v1";
            apiKey = "{file:${config.sops.secrets.litellm-api-key.path}}";
          };
          models = {
            "gemini-3.8-flash" = {
              name = "gemini-3.8-flash";
            };
            "gemini-3.5-flash-lite" = {
              name = "gemini-3.5-flash-lite";
            };
            "gemma-4-31b-it" = {
              name = "gemma-4-31b-it";
            };
            "gemma-4-26b-a4b-it" = {
              name = "gemma-4-26b-a4b-it";
            };
            "qwen3.8-27b" = {
              name = "qwen3.8-27b";
            };
            "glm-5.2" = {
              name = "glm-5.2";
            };
            "gpt-oss-20b" = {
              name = "gpt-oss-20b";
            };
            "gpt-oss-120b" = {
              name = "gpt-oss-120b";
            };
            "nemotron-3-super-120b-a12b" = {
              name = "nemotron-3-super-120b-a12b";
            };
            "nemotron-3-ultra-550b-a55b" = {
              name = "nemotron-3-ultra-550b-a55b";
            };
            "nemotron-3.5-lightning" = {
              name = "nemotron-3.5-lightning";
            };
            "north-mini-code" = {
              name = "north-mini-code";
            };
          };
        };
      };

      permission = {
        edit = "ask";
        bash = "ask";
      };

      plugin = [
        "@warp-dot-dev/opencode-warp"
      ];
    };
    enableMcpIntegration = true;
  };
}

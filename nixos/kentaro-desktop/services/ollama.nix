{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama-cuda;
    environmentVariables = {
      LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
    };

    loadModels = [
      # General
      "gpt-oss:20b-cloud"
      "gpt-oss:120b-cloud"
      "deepseek-v3.1:671b-cloud"
      "qwen3.5:cloud"

      # Coding
      "qwen3-coder:480b-cloud"
      "qwen3-coder-next:cloud"
      "qwen2.5:1.5b"
      "glm-5:cloud"
      "kimi-k2.5:cloud"

      # Continue
      "llama3.1:8b"
      "qwen2.5-coder:7b-instruct"
      "qwen2.5-coder:1.5b-base"
      "nomic-embed-text:latest"
    ];
  };
}

{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama-cuda;
    environmentVariables = {
      LD_LIBRARY_PATH = "${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH";
    };

    loadModels = [
      # OpenAI
      "gpt-oss:20b-cloud"
      "gpt-oss:120b-cloud"

      # Roo Code
      "qwen3-coder:480b-cloud"
      "deepseek-v3.1:671b-cloud"

      # Continue
      "llama3.1:8b"
      "qwen2.5-coder:7b-instruct"
      "qwen2.5-coder:1.5b-base"
      "nomic-embed-text:latest"
    ];
  };
}

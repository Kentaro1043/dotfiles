{pkgs, ...}: {
  services.open-webui = {
    enable = true;
    package = pkgs.unstable.open-webui;
    port = 11111;
    environment = {
      # API
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";

      # Auth
      WEBUI_AUTH = "False";

      # Telemetry
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
    };
  };
}

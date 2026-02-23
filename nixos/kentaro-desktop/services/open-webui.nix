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

      # Web Search
      ENABLE_WEB_SEARCH = "True";
      ENABLE_SEARCH_QUERY_GENERATION = "True";
      WEB_SEARCH_RESULT_COUNT = "3";
      WEB_SEARCH_CONCURRENT_REQUESTS = "0"; # Unlimit
      WEB_LOADER_CONCURRENT_REQUESTS = "10";
      WEB_SEARCH_ENGINE = "duckduckgo";

      # Telemetry
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
    };
  };
}

{...}: {
  imports = [./grafana-mcp.nix ./joplin-mcp.nix];

  programs.mcp = {
    enable = true;
    servers.science-tokyo-syllabus.url = "https://syllabus.s.isct.ac.jp/mcp";
  };
}

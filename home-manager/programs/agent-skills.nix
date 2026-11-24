{...}: {
  programs.agent-skills = {
    enable = true;

    sources = {
      local.path = ../../skills;
      codex = {
        input = "codex-skills";
        subdir = "skills/.curated";
      };
      mdx = {
        input = "mdx-cli";
        subdir = "skills";
      };
      yomiyasu = {
        input = "yomiyasu";
        subdir = "skills";
      };
      vercel = {
        input = "vercel-skills";
        subdir = "skills";
      };
      orca = {
        input = "orca-skills";
        subdir = "skills";
      };
      mattpocock-engineering = {
        input = "mattpocock-skills";
        subdir = "skills/engineering";
      };
      mattpocock-productivity = {
        input = "mattpocock-skills";
        subdir = "skills/productivity";
      };
    };

    skills.enable = [
      # local
      "sites-local"

      # codex
      "jupyter-notebook"
      "openai-docs"
      "pdf"
      "playwright"
      "yeet"

      # mdx
      "mdx-cli"

      # yomiyasu
      "yomiyasu"

      # vercel
      "find-skills"

      # orca
      "orca-cli"
      "orca-computer-use"
      "orchestration"

      # mattpocock / engineering
      "code-review"
      "codebase-design"
      "diagnosing-bugs"
      "domain-modeling"
      "grill-with-docs"
      "implement"
      "pr"
      "prototype"
      "research"
      "tdd"
      "wizard"

      # mattpocock / productivity
      "grill-me"
      "grilling"
      "writing-for-agents"
    ];

    targets.agents = {
      enable = true;
      structure = "link";
      dest = ".agents/skills";
    };
  };
}

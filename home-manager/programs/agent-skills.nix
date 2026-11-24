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
      # model-invoked
      "code-review"
      "codebase-design"
      "diagnosing-bugs"
      "domain-modeling"
      "pr"
      "prototype"
      "research"
      "tdd"
      "wizard"
      # user-invoked
      "grill-with-docs"
      "implement"

      # mattpocock / productivity
      # model-invoked
      "grilling"
      "writing-for-agents"
      # user-invoked
      "grill-me"
    ];

    targets.agents = {
      enable = true;
      structure = "link";
      dest = ".agents/skills";
    };
  };
}

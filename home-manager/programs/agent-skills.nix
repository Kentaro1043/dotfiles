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
    };

    skills.enable = [
      "find-skills"
      "gh-address-comments"
      "gh-fix-ci"
      "jupyter-notebook"
      "mdx-cli"
      "openai-docs"
      "orca-cli"
      "orca-computer-use"
      "orchestration"
      "pdf"
      "playwright"
      "screenshot"
      "security-best-practices"
      "security-threat-model"
      "sites-local"
      "yeet"
      "yomiyasu"
    ];

    targets.agents = {
      enable = true;
      structure = "link";
      dest = ".agents/skills";
    };
  };
}

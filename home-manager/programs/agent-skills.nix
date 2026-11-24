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
      mattpocock = {
        input = "mattpocock-skills";
        subdir = "skills";
        filter.nameRegex = "(engineering|in-progress|misc|productivity)/[^/]+";
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

    skills.explicit.grilling = {
      from = "mattpocock";
      path = "productivity/grilling";
    };

    targets.agents = {
      enable = true;
      structure = "link";
      dest = ".agents/skills";
    };
  };
}

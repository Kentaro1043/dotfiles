{inputs}: let
  curatedSkillNames = [
    "gh-address-comments"
    "gh-fix-ci"
    "jupyter-notebook"
    "openai-docs"
    "pdf"
    "playwright"
    "screenshot"
    "security-best-practices"
    "security-threat-model"
    "yeet"
  ];
  curatedSkill = name: {
    inherit name;
    source = inputs.codex-skills + "/skills/.curated/${name}";
  };
in
  map curatedSkill curatedSkillNames
  ++ [
    {
      name = "mdx-cli";
      source = inputs.mdx-cli + "/skills/mdx-cli";
    }
  ]

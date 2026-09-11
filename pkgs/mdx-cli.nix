{
  lib,
  python313Packages,
  src,
}:
python313Packages.buildPythonApplication rec {
  pname = "mdx-cli";
  version = "2.1.1";
  pyproject = true;

  inherit src;

  build-system = with python313Packages; [hatchling];

  dependencies = with python313Packages; [
    beautifulsoup4
    cryptography
    httpx
    keyring
    pydantic
    pydantic-settings
    questionary
    typer
  ];

  pythonImportsCheck = ["mdx_cli"];

  meta = {
    description = "Unofficial CLI for the MDX cloud infrastructure platform";
    homepage = "https://github.com/aida0710/mdx-cli";
    license = lib.licenses.mit;
    mainProgram = "mdx";
  };
}

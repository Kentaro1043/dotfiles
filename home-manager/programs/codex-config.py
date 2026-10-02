import os
import pathlib
import subprocess
import sys
from urllib.parse import quote


source, secret, target, sops_file, age_key_file, sops = map(
    pathlib.Path, sys.argv[1:]
)
if secret.exists():
    token = secret.read_text().strip()
else:
    env = os.environ.copy()
    env["SOPS_AGE_KEY_FILE"] = str(age_key_file)
    token = subprocess.check_output(
        [str(sops), "decrypt", "--extract", '["joplin-api-token"]', str(sops_file)],
        env=env,
        text=True,
    ).strip()

if not token:
    raise ValueError("Joplin API token is empty")

target.write_text(source.read_text().replace("@joplinToken@", quote(token, safe="")))

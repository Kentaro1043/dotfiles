---
name: sites-local
description: Create or update websites and deploy them to the local static hosting service when publication is requested, or delete a hosted site on explicit request.
---

# Local sites

Interpret the request and choose an appropriate stack for a new site, such as plain HTML/CSS/JavaScript or Vite with React and TypeScript. Create a new project in the current directory. For an existing site, respect its stack. Decide ambiguous details independently and ask only for essential missing information. The hosting service serves static files via nginx; it cannot run backend code.

Build the site if necessary. Deploy only when the user requests publication or deployment; a request solely to create a site does not authorize deployment.

## Publish

The rsync daemon is at `rsync://192.168.1.3:30873/sites/`; SSH, authentication, and a dedicated CLI are unnecessary. A site's URL is `https://<site>.sites.internal.kentaro1043.com/`.

Keep the site name as the only line in `.sites` at the project root. It must be a single lowercase DNS label of 1–63 ASCII letters, digits, and hyphens, beginning and ending with a letter or digit. Reuse an existing `.sites` name for updates; prioritize an explicitly requested name. Before the first deployment, list the daemon's sites with `rsync rsync://192.168.1.3:30873/sites/` and choose an unused name, generating one automatically if none was specified. Never overwrite a different existing site: if a requested name is occupied, resolve the conflict with the user. If listing fails, investigate rather than assume a name is free. Write the chosen name to `.sites`.

Transfer only build output, or the files needed to serve a plain HTML site. Inspect the source for unintended files, and exclude `.git`, `.env*`, `.sites`, `node_modules`, and other secrets or development files. Validate the source and destination paths and ensure the destination is exactly the validated site's directory before using `--delete`:

```sh
rsync -rt --delete --mkpath \
  --exclude='.git' --exclude='.env*' --exclude='.sites' --exclude='node_modules' \
  <SOURCE>/ rsync://192.168.1.3:30873/sites/<site>/
```

Investigate deployment failures. After a successful transfer, verify the public URL with `curl --fail --silent --show-error https://<site>.sites.internal.kentaro1043.com/`. Report the URL only after verification succeeds; do not claim publication succeeded otherwise.

## Delete

Delete a site only when the user explicitly requests it. Validate the requested site name and confirm that the destination is exactly `rsync://192.168.1.3:30873/sites/<site>/`, never the sites root or another site. Sync an empty directory to that destination with `rsync -rt --delete` to remove its contents. Investigate failures and report the actual result.

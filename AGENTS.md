# AGENTS.md

## Project goal

This repository packages the npm release of `meshcommander` as a minimal Docker image and publishes that image through GitHub Actions.

## Important files

- [`Dockerfile`](Dockerfile): installs `meshcommander` from npm using the `MESHCOMMANDER_VERSION` build arg.
- [`build_run.sh`](build_run.sh): local smoke-test helper for building and running the container.
- [`docker-compose.yml`](docker-compose.yml): sample local deployment using the same runtime hardening flags as the helper script.
- [`.github/workflows/build-meshcommander.yml`](.github/workflows/build-meshcommander.yml): CI workflow that resolves the npm version and publishes a tagged image.

## Maintenance guidance

- Keep the container focused on serving MeshCommander; avoid adding unrelated services or process managers.
- Prefer build-time version pinning through `MESHCOMMANDER_VERSION` instead of hardcoding a package version in the Dockerfile.
- Preserve the current low-privilege runtime defaults unless there is a clear reason to change them:
  - `cap_drop: ALL`
  - `no-new-privileges:true`
- If the workflow changes, keep image tags tied to the npm package version so the published container remains easy to trace back to upstream.
- When updating docs, treat the compose file as a sample for local use and the GitHub Actions workflow as the authoritative release path.

## Verification expectations

- For Docker-related changes, verify syntax and build arguments at minimum.
- If Docker is available, prefer validating with a local `docker build` or `docker compose config`.
- If execution is not possible in the current environment, document that clearly in the final handoff.

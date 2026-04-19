# MeshCommanderContainer

Container packaging for [MeshCommander](https://github.com/Ylianst/MeshCommander) using the npm-distributed `meshcommander` package.

## What this repo provides

- A simple Docker image that installs MeshCommander from npm.
- A sample `docker-compose.yml` for local use.
- A GitHub Actions workflow that builds and publishes a versioned container image.
- A small helper script for local build-and-run testing.

## Local build and run

Build and run the image with the helper script:

```bash
./build_run.sh
```

Override the MeshCommander version or port if needed:

```bash
MESHCOMMANDER_VERSION=0.9.5-a HOST_PORT=3000 ./build_run.sh
```

The container listens on port `3000` and starts MeshCommander with:

```bash
node node_modules/meshcommander --any
```

## Docker Compose

The included [`docker-compose.yml`](docker-compose.yml) builds this repo locally and mirrors the hardened runtime flags from `build_run.sh`.

Example:

```bash
docker compose up --build -d
```

You can override the default version and host port with environment variables:

```bash
MESHCOMMANDER_VERSION=0.9.5-a HOST_PORT=3000 docker compose up --build -d
```

The sample runtime is hardened with:

- a read-only root filesystem
- `tmpfs` mounted at `/tmp`
- `cap_drop: ALL`
- `no-new-privileges:true`
- an internal-only Docker network to prevent normal outbound internet access at runtime while still exposing the published service port

## GitHub Actions image build

The workflow at [`.github/workflows/build-meshcommander.yml`](.github/workflows/build-meshcommander.yml) does the following:

- Resolves the current `meshcommander` version directly from npm at build time.
- Checks whether `ghcr.io/<owner>/meshcommander:<npm-version>` already exists and skips the build if it does.
- Builds a multi-architecture image for `linux/amd64` and `linux/arm64`.
- Pushes tags to GitHub Container Registry as:
  - `ghcr.io/<owner>/meshcommander:<npm-version>`
  - `ghcr.io/<owner>/meshcommander:latest`
  - `ghcr.io/<owner>/meshcommander:sha-<commit>`

It runs on manual dispatch, on pushes to `main` or `master` that touch the container files, and on a weekly schedule.

## Published package

When the workflow publishes successfully, the container package is available from GitHub Container Registry at:

- [`ghcr.io/megascope/meshcommander`](https://github.com/users/megascope/packages/container/package/meshcommander)

Release-style tags follow this pattern:

- `<npm-version>` for the upstream MeshCommander release, for example `0.9.5-a`
- `latest` for the most recently published build
- `sha-<commit>` for traceability back to the source commit

Pull the image:

```bash
docker pull ghcr.io/megascope/meshcommander:latest
```

Or pin a specific upstream MeshCommander version:

```bash
docker pull ghcr.io/megascope/meshcommander:0.9.5-a
```

Run the published image directly:

```bash
docker run -d \
  --name meshcommander \
  -p 3000:3000 \
  --read-only \
  --tmpfs /tmp \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  ghcr.io/megascope/meshcommander:latest
```

## Notes

- The sample compose file defaults to `0.9.5-a`, which matched the latest `meshcommander` package version visible from npm package metadata on April 18, 2026.
- The GitHub Actions workflow does not rely on that default; it resolves the live npm version each time it runs.

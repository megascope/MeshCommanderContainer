#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-meshcommander}"
CONTAINER_NAME="${CONTAINER_NAME:-meshcommander}"
HOST_PORT="${HOST_PORT:-3000}"
CONTAINER_PORT="${CONTAINER_PORT:-3000}"
MESHCOMMANDER_VERSION="${MESHCOMMANDER_VERSION:-latest}"

docker build \
  --build-arg "MESHCOMMANDER_VERSION=${MESHCOMMANDER_VERSION}" \
  -t "${IMAGE_NAME}:${MESHCOMMANDER_VERSION}" \
  .

docker run -d \
  --name "${CONTAINER_NAME}" \
  -p "${HOST_PORT}:${CONTAINER_PORT}" \
  --read-only \
  --tmpfs /tmp \
  --cap-drop ALL \
  --security-opt no-new-privileges:true \
  "${IMAGE_NAME}:${MESHCOMMANDER_VERSION}"

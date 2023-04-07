# Compose@Edge TypeScript Docker

## Introduction

This repo contains an attempt to run the Fastly CLI local server in a Docker
container. It is based on:

- [`fastly/compute-starter-kit-typescript`](https://github.com/fastly/compute-starter-kit-typescript/pull/4)
- [`fastly/cli/Dockerfile-node`](https://github.com/fastly/cli/blob/main/Dockerfile-node)

## Running from docker

Requires Docker. Run:

```sh
docker-compose up
```

## Running on host machine

Requires pnpm. Run:

```sh
pnpm install
pnpm run dev
```

## Issue

On my machine (an Apple Silicon M2 MacBook Pro), the Fastly CLI builds the
service successfully, starts the server, and then immediately shuts down as if
from a SIGINT (no error):

```
compute-edge-ts-docker-compute_edge-1  | SUCCESS: Built package (pkg/compute-edge-ts-docker.tar.gz)
compute-edge-ts-docker-compute_edge-1  |
compute-edge-ts-docker-compute_edge-1  | | Running local server...
compute-edge-ts-docker-compute_edge-1  | ✓ Running local server
compute-edge-ts-docker-compute_edge-1  |
compute-edge-ts-docker-compute_edge-1  | Manifest: /app/fastly.toml
compute-edge-ts-docker-compute_edge-1  | Wasm binary: bin/main.wasm
compute-edge-ts-docker-compute_edge-1  | Viceroy binary: /home/fastly/.config/fastly/viceroy
compute-edge-ts-docker-compute_edge-1  | Viceroy version: viceroy 0.4.3
compute-edge-ts-docker-compute_edge-1  |
compute-edge-ts-docker-compute_edge-1  | INFO: Command output:
compute-edge-ts-docker-compute_edge-1  | --------------------------------------------------------------------------------
compute-edge-ts-docker-compute_edge-1  | --------------------------------------------------------------------------------
compute-edge-ts-docker-compute_edge-1  |
compute-edge-ts-docker-compute_edge-1  | INFO: Local server stopped
compute-edge-ts-docker-compute_edge-1 exited with code 0
```

Running from the host machine with `pnpm run dev` works correctly.

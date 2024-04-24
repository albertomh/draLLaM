<!-- markdownlint-disable MD041 -->
![draLLaM arrow logo](draLLaM.svg "DepositDuck draLLaM")

DepositDuck's LLM service.  
Produces a single artefact: a container image that provides an endpoint to
generate token embeddings. Powered by `ollama`.

## Develop

[![GNU make](https://img.shields.io/badge/GNU_make-f2efe4?logo=gnu&logoColor=a32d2a)](https://github.com/pre-commit/pre-commit)
[![pre-commit](https://img.shields.io/badge/pre--commit-FAB040?logo=pre-commit&logoColor=1f2d23)](https://github.com/pre-commit/pre-commit)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=ffffff)](https://docs.docker.com/manuals/)
[![ollama](https://img.shields.io/badge/%F0%9F%A6%99%20ollama-black.svg)](https://ollama.com/)

### Prerequisites

To develop the DepositDuck LLM service, the following must be available locally:

- [make](https://www.gnu.org/software/make/)
- [pre-commit](https://pre-commit.com/)
- [Docker](https://docs.docker.com/)
- [ollama](https://ollama.com/download)

### Quickstart: run locally

A `makefile` defines common development tasks. Run `make` or `make help` to show all
available targets.

TODO: replace `makefile` with a `justfile`.
TODO: improve dev workflow by wrapping steps as `just` recipes.

```sh
# ollama-specific files must be present in the Docker build context
# NB. tried using symlinks instead but Docker didn't like them.
blobs=".ollama/models/blobs" \
nomic=".ollama/models/manifests/registry.ollama.ai/library/nomic-embed-text" && \
mkdir -p "$blobs" "$nomic" && \
cp -a "$HOME/$blobs/." "./$blobs" && \
cp -a "$HOME/$nomic/." "./$nomic"

# build the container image locally
make build

# run the embeddings service locally, available on :11434
make run

# interact with the embeddings service
# Important! Must specify the tagged model name for
# the `model` parameter.
curl http://localhost:11434/api/embeddings -d '{
  "model": "nomic-embed-text:v1.5",
  "prompt": "The sky above the port was the color of television, tuned to a dead channel."
}'
```

### Build requirements

The following workflow is needed to allow model blobs to be baked into the resulting
container image. This is due to restrictions on running `ollama serve` and `ollama pull`
as `RUN` commands in the Dockerfile at the build stage.

```sh
# locally on host system:
ollama serve & \
sleep 10 && \
ollama pull nomic-embed-text:v1.5
```

This will place model blobs & manifest files in the canonical locations under `~/.ollama/`,
which must be copied to the build directory before running `make build` - see [Quickstart](#quickstart-run-locally).

### Development workflow

This repo follows trunk-based development. This means:

- the `main` branch should always be in a releasable state
- use short-lived feature branches

Pre-commit hooks are available to prevent common gotchas and to lint & format code.

```sh
# install pre-commit hooks
pre-commit install
```

Please follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
guidelines when writing commit messages.
`commitlint` is enabled as a pre-commit hook. Valid commit types are defined in `.commitlintrc.yaml`.

## Continuous Integration

Continuous Integration pipelines run via GitHub Actions on push.  
Pipelines are defined by YAML files in the `.github/workflows/` directory.
There are two workflows:

- When a commit on a feature branch is pushed up to GitHub - `pr.yaml`
- When a Pull Request is merged into the 'main' branch - `ci.yaml`

They both run pre-commit hooks against the codebase. `ci.yaml` additionally creates a tag
and GitHub release when a release branch (see below) is merged.

## Deploy

### Cut a release

1. Pick the semver number (`X.Y.Z`) for the release.
1. Run `make release v=X.Y.Z`  
   This stamps the changelog and triggers a GitHub pipeline.
1. Wait for the pipeline to succeed. It will have raised a PR for this release.
1. Review and merge (merge-and-rebase) the PR.
1. This will trigger a pipeline to tag the `main` branch and create a GitHub release.

### Build and tag a container image

Containers must be built locally in order to bake model blob and manifest files into the
image. Do this with:

```sh
# by default will use the latest tag fetched from the remote origin
./local/containerise_from_tag.sh

# optionally, specify the tag to build from
./local/containerise_from_tag.sh X.Y.Z
```

---

&copy; 2024 Alberto MH  
This work is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

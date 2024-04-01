# draLLaM

DepositDuck's LLM service.  
This project produces a single artefact: a container image that provides an endpoint to
generate token embeddings. Powered by `ollama`.

## Develop

[![pre-commit](https://img.shields.io/badge/pre--commit-FAB040?logo=pre-commit&logoColor=1f2d23)](https://github.com/pre-commit/pre-commit)

### Prerequisites

To develop the DepositDuck LLM service, the following must be available locally:

- [make](https://www.gnu.org/software/make/)
- [pre-commit](https://pre-commit.com/)
- [Docker](https://docs.docker.com/)
- [ollama](https://ollama.com/download)

### Quickstart: run locally

A `makefile` defines common development tasks. Run `make` or `make help` to show all
available targets.

```sh
# ollama-specific files must be present in the Docker build context
# NB. tried using symlinks instead but Docker didn't like them.
blobs=".ollama/models/blobs" nomic=".ollama/models/manifests/registry.ollama.ai/library/nomic-embed-text" && \
mkdir -p "$blobs" "$nomic" && \
cp -a "$HOME/$blobs/." "./$blobs" && \
cp -a "$HOME/$nomic/." "./$nomic"

# build the container image locally
make build

# run the embeddings service locally, available on :11434
make run

# interact with the embeddings service
# Important! Must specify the tagged model name for the `model` parameter.
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
ollama serve & sleep 10 && ollama pull nomic-embed-text:v1.5
```

This will place model blobs & manifest files in the canonical locations under `~/.ollama/`,
which must be copied to the build directory before running `make build` (see Quickstart).

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

##  Continuous Integration

## Deploy

### Cut a release

---
&copy; 2024 Alberto MH  
This work is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

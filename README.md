# draLLaM

DepositDuck's LLM service

## Develop

[![pre-commit](https://img.shields.io/badge/pre--commit-FAB040?logo=pre-commit&logoColor=1f2d23)](https://github.com/pre-commit/pre-commit)

### Prerequisites
To develop the DepositDuck LLM service, the following must be available locally:

- [make](https://www.gnu.org/software/make/)
- [pre-commit](https://pre-commit.com/)
- [Docker](https://docs.docker.com/)

### Quickstart: run locally

A `makefile` defines common development tasks. Run `make` or `make help` to show all
available targets.

```sh
```

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

## Project structure

## Test

### Prerequisites

### Run tests locally

##  Continuous Integration

## Deploy

### Cut a release

---
&copy; 2024 Alberto MH  
This work is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

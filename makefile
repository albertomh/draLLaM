# draLLaM: DepositDuck's LLM service - local development tooling
#
# (c) 2024 Alberto Morón Hernández

# run all targets & commands in the same shell instance
.ONESHELL:

PROJECT_NAME=draLLaM
IMAGE_NAME=drallam

.PHONY: *

# default target
all: help

build:
	@docker build \
	--no-cache \
	--tag $(IMAGE_NAME) \
	.

wipe:
	@docker system prune --all --volumes --force
	@docker builder prune --all --force

run:
	@docker run \
	  --rm \
	  --publish 11434:11434 \
	  --name $(PROJECT_NAME) \
	  $(IMAGE_NAME)

shell:
	@docker exec \
	--interactive \
	--tty \
	$(PROJECT_NAME) \
	bash

# cut a release and raise a pull request for it
release:
	@$(if $(v),,$(error please specify 'v=X.Y.Z' tag for the release))
	./local/cut_release.sh $(v)

help:
	@echo "usage: make [target]"
	@echo "  help                Show this help message\n"
	@echo "  build               Build the draLLaM Docker image"
	@echo "  wipe                Remove unused Docker containers and wipe the build cache\n"
	@echo "  run                 Start a draLLaM container\n"
	@echo "  shell               Interactive shell session inside the container\n"
	@echo "  release v=X.Y.Z     Cut a release and raise a pull request for it\n"

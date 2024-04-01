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

help:
	@echo "usage: make [target]"
	@echo "  help                Show this help message\n"
	@echo "  build               Build the draLLaM Docker image\n"
	@echo "  run                 Start a draLLaM container\n"
	@echo "  shell               Interactive shell session inside the container\n"

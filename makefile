# draLLaM: DepositDuck's LLM service - local development tooling
#
# (c) 2024 Alberto Morón Hernández

# run all targets & commands in the same shell instance
.ONESHELL:


.PHONY: *

# default target
all: help

help:
	@echo "usage: make [target]"
	@echo "  help                Show this help message\n"

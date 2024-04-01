#!/usr/bin/env bash

# Containerise draLLaM, baking in model blob and manifest files.
# Prerequisite:
#   - ollama-specific files must be present in `.ollama/` in the Docker build context.
#
# Usage:
#   ./local/containerise_from_tag.sh [tag]
#
# If no tag is provided as the first parameter the latest SemVer-compatible tag will be used.
#
# (c) 2024 Alberto Morón Hernández


SEMVER_REGEX='^[0-9]+\.[0-9]+\.[0-9]+$'
LOCAL_OLLAMA_DIR=".ollama"


if [ ! -d "$LOCAL_OLLAMA_DIR/" ]; then
    echo "Error: directory .ollama/ does not exist"
    exit 1
fi

if [ ! -d "$LOCAL_OLLAMA_DIR/models/blobs" ] || [ ! "$(ls -A $LOCAL_OLLAMA_DIR/models/blobs)" ]; then
    echo "Error: directory $LOCAL_OLLAMA_DIR/models/blobs does not exist or is empty"
    exit 1
fi

if [ ! -d "$LOCAL_OLLAMA_DIR/models/manifests" ] || [ ! "$(ls -A $LOCAL_OLLAMA_DIR/models/manifests)" ]; then
    echo "Error: directory $LOCAL_OLLAMA_DIR/models/manifests does not exist or is empty"
    exit 1
fi

git fetch --tags 2>/dev/null || { echo "Error: Failed to fetch tags"; exit 1; }

if [ "$#" -eq 1 ]; then
    tag_to_checkout="$1"
    echo "Attempting to check out user-provided tag: $tag_to_checkout"
    git checkout "$tag_to_checkout" 2>/dev/null || { echo "Error: failed to checkout user-provided tag: $tag_to_checkout"; exit 1; }
fi

if [ -z "$(git describe --tags 2>/dev/null)" ]; then
    latest_semver_tag=$(git tag -l --sort=-v:refname 'v[0-9]*.[0-9]*.[0-9]*' | head -n 1)
    if [ -n "$latest_semver_tag" ]; then
        echo "No user-provided tag specified. Using the latest SemVer tag: $latest_semver_tag"
        git checkout "$latest_semver_tag" 2>/dev/null || { echo "Error: failed to check out latest SemVer tag: $latest_semver_tag"; exit 1; }
    else
        echo "Error: No tags matching SemVer format found"
        exit 1
    fi
fi

current_tag=$(git describe --tags 2>/dev/null)

docker build \
  --no-cache \
  --tag "drallam:$current_tag" \
  .

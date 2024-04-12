#!/bin/sh
set -x

# Prepare the enviroment
mkdir -p artifact
cd artifact
apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    zip \
    wget

# Define the path to the godot-base Dockerfile
BASE_DOCKERFILE="../Dockerfile.base"

# Use grep to extract ENV values from the Dockerfile and use cut to parse the value
export GODOT_VERSION=$(grep "^ENV GODOT_VERSION=" $BASE_DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')
export GODOT_RELEASE_NAME=$(grep "^ENV GODOT_RELEASE_NAME=" $BASE_DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')

# Download godot export templates
wget --no-verbose https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE_NAME}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_export_templates.tpz \
    && unzip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_export_templates.tpz \
    && rm -f Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_export_templates.tpz

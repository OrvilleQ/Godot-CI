#!/bin/sh
set -x

# Prepare enviroment
mkdir -p artifact
cd artifact
apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    unzip \
    zip \
    wget

# Extract ARG from Dockerfile
DOCKERFILE="../Dockerfile"
export GODOT_VERSION=$(grep "^ARG GODOT_VERSION=" $DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')
export GODOT_RELEASE_NAME=$(grep "^ARG GODOT_RELEASE_NAME=" $DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')

# Download godot export templates
wget --no-verbose https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE_NAME}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_export_templates.tpz \
    && unzip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_export_templates.tpz \
    && rm -f Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_export_templates.tpz

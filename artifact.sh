#!/bin/sh
set -xe

# Prepare enviroment
mkdir -p artifact
cd artifact
apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    unzip \
    zip \
    wget

# Extract ENV from Dockerfile
DOCKERFILE="../Dockerfile.base"
export GODOT_VERSION=$(grep "^ENV GODOT_VERSION=" $DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')
export GODOT_RELEASE_CHANNEL=$(grep "^ENV GODOT_RELEASE_CHANNEL=" $DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')

# Download godot export templates
wget --no-verbose https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_export_templates.tpz \
    && unzip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_export_templates.tpz \
    && rm -f Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_export_templates.tpz

# Download godot .net export templates
wget --no-verbose https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_export_templates.tpz \
    && unzip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_export_templates.tpz -d dotnet \
    && rm -f Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_export_templates.tpz

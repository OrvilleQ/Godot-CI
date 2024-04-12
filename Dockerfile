FROM debian:12-slim
LABEL org.opencontainers.image.authors="Orville Q. Song <orville@anislet.dev>"

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    zip \
    wget \
    && rm -rf /var/lib/apt/lists/*

ARG GODOT_VERSION=4.2.1
ARG GODOT_RELEASE_CHANNEL=stable
ARG TARGETPLATFORM

COPY artifact/templates/ /root/.local/share/godot/export_templates/${GODOT_VERSION}.${GODOT_RELEASE_NAME}/

COPY add.sh /usr/local/bin/add
RUN add godot

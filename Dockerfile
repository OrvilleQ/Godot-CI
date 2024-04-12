FROM debian:12-slim
LABEL org.opencontainers.image.authors="Orville Q. Song <orville@anislet.dev>"

USER root
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    zip \
    wget

ARG GODOT_VERSION=4.2.1
ARG GODOT_RELEASE_NAME=stable
ARG TARGETPLATFORM

COPY artifact/templates/ /root/.local/share/godot/export_templates/${GODOT_VERSION}.${GODOT_RELEASE_NAME}/

RUN echo "Selecting platform for $TARGETPLATFORM" && \
    case "$TARGETPLATFORM" in \
    "linux/amd64") \
        GODOT_PLATFORM="linux.x86_64";; \
    "linux/386") \
        GODOT_PLATFORM="linux.x86_32";; \
    "linux/arm64") \
        GODOT_PLATFORM="linux.arm64";; \
    "linux/arm/v7") \
        GODOT_PLATFORM="linux.arm32";; \
    *) \
        echo "Unsupported platform: $TARGETPLATFORM"; \
        exit 1 ;; \
    esac && \
    echo "Using GODOT_PLATFORM=${GODOT_PLATFORM}" && \
    wget --no-verbose https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE_NAME}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_${GODOT_PLATFORM}.zip \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && unzip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_${GODOT_PLATFORM}.zip \
    && mv Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_${GODOT_PLATFORM} /usr/local/bin/godot \
    && rm -f Godot_v${GODOT_VERSION}-${GODOT_RELEASE_NAME}_${GODOT_PLATFORM}.zip

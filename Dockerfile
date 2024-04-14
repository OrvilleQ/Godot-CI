ARG FROM_TARGET
FROM ${FROM_TARGET}

ARG GODOT_VERSION=4.2.1
ARG GODOT_RELEASE_CHANNEL=stable
ARG GODOT_FLAVOUR=standard
ARG TARGETPLATFORM

COPY artifact/templates/ /root/.local/share/godot/export_templates/${GODOT_VERSION}.${GODOT_RELEASE_NAME}/

COPY add.sh /usr/local/bin/add
RUN add godot

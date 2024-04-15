ARG FROM_TARGET
FROM ${FROM_TARGET}

ARG GODOT_FLAVOUR=standard

COPY artifact/templates/ /root/.local/share/godot/export_templates/${GODOT_VERSION}.${GODOT_RELEASE_NAME}/

RUN add godot

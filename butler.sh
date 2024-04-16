#!/bin/sh
set -xe

build() {
    git clone https://github.com/itchio/butler.git
    cd butler
    git checkout ${BUTLER_VERSION}

    BUTLER_BUILTAT=$(date +%s)
    BUTLER_BUILDINFO=github.com/itchio/butler/buildinfo
    BUTLER_COMMIT=$(git rev-parse HEAD)

    CGO_ENABLED=1 go build -ldflags "-X ${BUTLER_BUILDINFO}.Version=${BUTLER_VERSION} -X ${BUTLER_BUILDINFO}.BuiltAt=${BUTLER_BUILTAT} -X ${BUTLER_BUILDINFO}.Commit=${BUTLER_COMMIT} -w -s"

    case $GODOT_CI_BUILDING_STAGE in
        "test")
            echo "Skipping upload."
            ;;
        *)
            echo "Uploading new build..."
            curl -s --upload-file butler -H "Authorization: token ${GODOT_CI_BUTLER_BR_ACCESS_TOKEN}" \
                "${GODOT_CI_BUTLER_BR}/${BUTLER_VERSION}/${BUTLER_NAME}"
            ;;
    esac
}

download() {
    echo "File exists. Downloading..."
    mkdir -p butler
    curl -s --output butler/butler -H "Authorization: token ${GODOT_CI_BUTLER_BR_ACCESS_TOKEN}" \
        "${GODOT_CI_BUTLER_BR}/${BUTLER_VERSION}/${BUTLER_NAME}"
    echo "Download completed!"
}

checkButlerExistence() {
    curl -s -w %{http_code} -o /dev/null -H "Authorization: token ${GODOT_CI_BUTLER_BR_ACCESS_TOKEN}" \
        -H "Range: bytes=0-0" \
        "${GODOT_CI_BUTLER_BR}/${BUTLER_VERSION}/${BUTLER_NAME}"
}

main() {
    DOCKERFILE=Dockerfile.base
    BUTLER_VERSION=v$(grep "^ENV BUTLER_VERSION=" $DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')

    case $TARGETPLATFORM in
        "linux/amd64")
            BUTLER_NAME="butler.x86_64"
            ;;
        "linux/386")
            BUTLER_NAME="butler.i686"
            ;;
        "linux/arm64")
            BUTLER_NAME="butler.aarch64"
            ;;
        "linux/arm/v7")
            BUTLER_NAME="butler.armv7l"
            ;;
        *)
            echo "Unsupported platform: $TARGETPLATFORM"
            exit 1
            ;;
    esac

    BUTLER_EXISTENCE=$(checkButlerExistence)
    

    
    if [ "$BUTLER_EXISTENCE" -eq 206 ]; then
        download
    elif [ "$BUTLER_EXISTENCE" -eq 404 ]; then
        build
    else
        echo "Unexpected HTTP status: $response_code"
        exit 1
    fi
}

main

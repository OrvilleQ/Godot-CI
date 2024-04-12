#!/bin/sh
set -e

addGodot () {
    # Determine GODOT_PLATFORM based on TARGETPLATFORM 
    case $TARGETPLATFORM in
        "linux/amd64")
            GODOT_PLATFORM="linux.x86_64"
            ;;
        "linux/386")
            GODOT_PLATFORM="linux.x86_32"
            ;;
        "linux/arm64")
            GODOT_PLATFORM="linux.arm64"
            ;;
        "linux/arm/v7")
            GODOT_PLATFORM="linux.arm32"
            ;;
        *)
            echo "Unsupported platform: $TARGETPLATFORM"
            exit 1
            ;;
    esac

    echo "Supported platform: ${GODOT_PLATFORM}"

    # Install Godot Engine    
    wget --no-verbose https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_${GODOT_PLATFORM}.zip
    mkdir -p ~/.cache
    mkdir -p ~/.config/godot
    unzip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_${GODOT_PLATFORM}.zip
    mv Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_${GODOT_PLATFORM} /usr/local/bin/godot
    rm -f Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_${GODOT_PLATFORM}.zip
}

main () {
    case $1 in
        "godot")
            echo "Installing Godot Engine..."
            addGodot
            ;;
        *)
            echo "Invalid argument ${1}."
            exit 1
            ;;
    esac
}

main "$1"

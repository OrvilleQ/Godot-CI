#!/bin/sh
set -xe

addGodot() {
    case $GODOT_FLAVOUR in
        "standard")
            addGodotStandard
            ;;
        "dotnet")
            addGodotDotNET
            ;;
        *)
            echo "Unknown Godot flavour ${GODOT_FLAVOUR}!!! Support standard and dotnet only!!!"
            exit 1
            ;;
    esac
}

addGodotStandard() {
    echo "Installing Godot Engine..."

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

addGodotDotNET() {
    echo "Installing Godot Engine .NET..."

    # Determine GODOT_PLATFORM based on TARGETPLATFORM 
    case $TARGETPLATFORM in
        "linux/amd64")
            GODOT_PLATFORM="linux_x86_64"
            GODOT_BINARY_PLATFORM="linux.x86_64"
            ;;
        "linux/arm64")
            GODOT_PLATFORM="linux_arm64"
            GODOT_BINARY_PLATFORM="linux.arm64"
            ;;
        "linux/arm/v7")
            GODOT_PLATFORM="linux_arm32"
            GODOT_BINARY_PLATFORM="linux.arm32"
            ;;
        *)
            echo "Unsupported platform: $TARGETPLATFORM"
            exit 1
            ;;
    esac

    echo "Supported platform: ${GODOT_PLATFORM}"

    # Install Godot Engine    
    wget --no-verbose https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_${GODOT_PLATFORM}.zip
    mkdir -p ~/.cache
    mkdir -p ~/.config/godot
    unzip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_${GODOT_PLATFORM}.zip
    mv Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_${GODOT_PLATFORM}/Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_${GODOT_BINARY_PLATFORM} /usr/local/bin/godot
    mv Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_${GODOT_PLATFORM}/GodotSharp /usr/local/bin/GodotSharp
    rm -rf Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_${GODOT_PLATFORM}.zip Godot_v${GODOT_VERSION}-${GODOT_RELEASE_CHANNEL}_mono_${GODOT_PLATFORM}

    # Install .NET SDK
    addDotNET
}

addDotNET() {
    echo "Installing .NET SDK..."

    apt-get update && apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu72 \
        libssl3 \
        libstdc++6 \
        zlib1g \
        && rm -rf /var/lib/apt/lists/*

    # Determine DOTNET_PLATFORM based on TARGETPLATFORM 
    case $TARGETPLATFORM in
        "linux/amd64")
            DOTNET_PLATFORM="x64"
            ;;
        "linux/arm64")
            DOTNET_PLATFORM="arm64"
            ;;
        "linux/arm/v7")
            DOTNET_PLATFORM="arm"
            ;;
        *)
            echo "Unsupported platform: $TARGETPLATFORM"
            exit 1
            ;;
    esac

    echo "Supported platform: ${DOTNET_PLATFORM}"

    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --architecture ${DOTNET_PLATFORM} --version ${DOTNET_SDK_VERSION}
} 

main () {
    case $1 in
        "godot")
            addGodot
            ;;
        *)
            echo "Invalid argument ${1}."
            exit 1
            ;;
    esac
}

main "$1"

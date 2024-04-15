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

    # Determine GODOT_PLATFORM based on GODOT_CI_PLATFORM 
    case $GODOT_CI_PLATFORM in
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
            echo "Unsupported platform: $GODOT_CI_PLATFORM"
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

    # Determine GODOT_PLATFORM based on GODOT_CI_PLATFORM 
    case $GODOT_CI_PLATFORM in
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
            echo "Unsupported platform: $GODOT_CI_PLATFORM"
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

    # Determine DOTNET_PLATFORM based on GODOT_CI_PLATFORM 
    case $GODOT_CI_PLATFORM in
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
            echo "Unsupported platform: $GODOT_CI_PLATFORM"
            exit 1
            ;;
    esac

    echo "Supported platform: ${DOTNET_PLATFORM}"

    curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --architecture ${DOTNET_PLATFORM} --version ${DOTNET_SDK_VERSION}
} 

addSteamCMD() {
    echo "Installing SteamCMD..."

    # Determine STEAMCMD_INSTALL based on GODOT_CI_PLATFORM 
    case $GODOT_CI_PLATFORM in
        "linux/amd64")
            STEAMCMD_INSTALL=1
            echo "Platform with SteamCMD support: $GODOT_CI_PLATFORM"
            ;;
        "linux/386")
            STEAMCMD_INSTALL=1
            echo "Platform with SteamCMD support: $GODOT_CI_PLATFORM"
            ;;
        "linux/arm64")
            STEAMCMD_INSTALL=0
            echo "Platform with no SteamCMD support: $GODOT_CI_PLATFORM"
            ;;
        "linux/arm/v7")
            STEAMCMD_INSTALL=0
            echo "Platform with no SteamCMD support: $GODOT_CI_PLATFORM"
            ;;
        *)
            echo "Unsupported platform: $GODOT_CI_PLATFORM"
            exit 1
            ;;
    esac

    case $STEAMCMD_INSTALL in
        "0")
            echo "Won't install SteamCMD."
            exit 0
            ;;
        "1")
            sed -i '/^Components: main$/ s/$/ contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources

            # Enable i386 on x86_64 platform
            if [ "$GODOT_CI_PLATFORM" = "linux/amd64" ]; then
                dpkg --add-architecture i386
            fi

            # Install SteamCMD
            echo steam steam/question select "I AGREE" | debconf-set-selections && echo steam steam/license note '' | debconf-set-selections
            apt-get update -y && apt-get install -y --no-install-recommends steamcmd && rm -rf /var/lib/apt/lists/*

            # Create symlink for executable
            ln -s /usr/games/steamcmd /usr/bin/steamcmd

            # Update SteamCMD and verify latest version
            steamcmd +quit

            # Fix missing directories and libraries
            mkdir -p $HOME/.steam \
            && ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
            && ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
            && ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
            && ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so
            ;;
        *)
            echo "Invalid option for STEAMCMD_INSTALL: $STEAMCMD_INSTALL"
            exit 1
            ;;
    esac
}

main () {
    case $1 in
        "godot")
            addGodot
            ;;
        "steamcmd")
            addSteamCMD
            ;;
        *)
            echo "Invalid argument ${1}."
            exit 1
            ;;
    esac
}

main "$1"

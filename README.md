# Godot-CI

[![status-badge](https://woodpecker.anislet.dev/api/badges/2/status.svg)](https://woodpecker.anislet.dev/repos/2)

Woodpecker plugin for Godot CI/CD.

## Feature Martix

| Platforms      | Standard Godot | Godot .NET | itch.io butler | SteamCMD |
| -------------- | -------------- | ---------- | -------------- | -------- |
| linux/amd64    | ✓              | ✓          | ✓              | ✓        |
| linux/386      | ✓              | ✗[^1]      | ✓              | ✓        |
| linux/arm64/v8 | ✓              | ✓          | ✓[^2]          | ✗[^3]    |
| linux/arm/v7   | ✓              | ✓          | ✓[^2]          | ✗[^3]    |

[^1]: Linux 32-bits is not supported by Microsoft and .NET.
[^2]: Unexpected issues may be encountered as butler does not explicitly state that it supports Arm.
[^3]: SteamCMD does not support Arm.

## Building

The Dockerfile and corresponding Woodpecker workflow in this repository are currently written specifically to run on a Woodpecker CI connected to a gitea/forgejo instance with package registry enabled, without the ability to build the container locally.

If you want to build it yourself, just fork this repository, enable woodpecker on it, and set secrets for the container registry (cr_token) and the binary registry (br_token), and everything should work automaticlly.

## Binary

The container image provided by this repository contain binaries from various sources.

- [Godot Engine & export templates](https://github.com/godotengine/godot)
- [.NET 6.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)
- [itch.io butler](https://github.com/itchio/butler) (Compiled at image build time)
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)

## Reference

- [abarichello/godot-ci](https://github.com/abarichello/godot-ci)
- [steamcmd/docker](https://github.com/steamcmd/docker)

## License

All source code in this repository is licensed under the [MIT License](LICENSE).

By building or using the linux/amd64 or linux/386 variants of the container, you automatically agree to the [Steam Install Agreement](SteamCMD.LICENSE).

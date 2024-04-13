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
[^2]: Unexpected issues may be encountered as bulter does not explicitly state that it supports Arm.
[^3]: SteamCMD does not support Arm.

## Binary

The container image provided by this repository contain binaries from various sources.

- [Godot Engine & export templates](https://github.com/godotengine/godot)
- [.NET 6.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)

## Reference

- [abarichello/godot-ci](https://github.com/abarichello/godot-ci)

## License

[MIT License](LICENSE).
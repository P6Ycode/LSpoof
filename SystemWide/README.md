# LSpoof System (rootless)

This target packages LSpoof as a rootless Theos tweak. Its Substrate-compatible filter loads the tweak into UIKit application processes, so the same spoofed location is visible to Apple and third-party apps, including Find My.

## Build

```sh
export THEOS=/path/to/theos
cd SystemWide
make clean package
```

The rootless package scheme installs the tweak under the jailbreak prefix (normally `/var/jb`) and produces an `iphoneos-arm64` Debian package. Building the arm64e slice requires a current macOS/Xcode toolchain.

## Install

```sh
make install
```

After installation, the target runs `sbreload`. Open any regular app and hold three fingers for 0.8 seconds to show the LSpoof picker. Static changes are synchronized through the shared preferences domain. Live route coordinates, heading, speed, and pause state are shared between running apps through Darwin notification state.

## Scope

This target injects into UIKit applications. It does not hook `locationd`, alter GNSS hardware data, spoof IP/Wi-Fi/cellular positioning, or affect processes blocked by the jailbreak's tweak-injection settings. Apps with tweak injection disabled must be enabled in the jailbreak configuration before LSpoof can load.

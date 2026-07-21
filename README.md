# LSpoof

LSpoof is a system-wide location simulation tweak for rootless jailbreaks. It injects into UIKit application processes so Apple and third-party apps read the same selected or simulated location.

## Features

- Three-finger, 0.8-second gesture opens the map picker from any injected app
- Static teleport with altitude, heading, fluctuation, recents, and bookmarks
- Walking, cycling, driving, and custom-speed route simulation
- Realistic acceleration and braking
- Pause reports 0 m/s, like stopping at a red light
- Shared preferences update running apps after location changes
- Live route coordinate, heading, speed, and pause state are shared across processes
- Safe fallback to the real location when no valid spoof source exists

## Requirements

- A rootless jailbreak with a Substrate-compatible tweak loader
- iOS 16 or later
- Theos with an iOS SDK
- A current macOS/Xcode toolchain when building the arm64e slice

## Build

```sh
export THEOS=/path/to/theos
make clean package
```

The rootless package scheme produces an `iphoneos-arm64` Debian package and installs files under the jailbreak prefix, normally `/var/jb`.

## Install

```sh
make install
```

Installation runs `sbreload`. Open any regular app, then hold three fingers for 0.8 seconds to open LSpoof.

## Injection scope

`LSpoof.plist` filters on `UIApplication`, covering normal UIKit apps including Find My when tweak injection is enabled for that process. LSpoof does not hook `locationd`, alter GNSS hardware data, spoof IP/Wi-Fi/cellular positioning, or bypass an app's server-side location checks.

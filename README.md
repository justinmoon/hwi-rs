# HWI (Rust port)

## Overview

This project attempts to port [HWI](https://github.com/bitcoin-core/HWI) to Rust, aiming to achieve:

- Android SDK
- Smaller binaries 
- Easier to produce binaries (HWI has elaborate Poetry + Docker setup to achieve this on Linux and Windows)
- Deterministic binaries on MacOS (HWI MacOS builds not currently deterministic)
- Faster and less resource-intensive in general (?) 
- `hwi enumerate` makes about 10 sequential calls to the USB port. Perhaps this Rust port could achieve a speedup by implementing this concurrently.

## Architecture

Goal is to implement the device serialization and HWI abstractions in one place, and to be able to plug in different serial communication. Android would be similar to Blockstream Green does for [Trezor](https://github.com/Blockstream/green_android/blob/05a3ec4730ffba72864b9e0219fb587b061977ba/app/src/main/java/com/satoshilabs/trezor/Trezor.java) and [Ledger](https://github.com/Blockstream/green_android/blob/43eceb2d20f1cad295dc6c66c956de67285846f4/app/src/main/java/com/btchip/comm/android/BTChipTransportAndroidHID.java). Desktop would use libusb/libhid like HWI currently does. AFAIK iOS doesn't support USB serial communication with hardware wallets, but perhaps you could build a BLE adapter which works like [Blockstream Green's iOS app](https://github.com/Blockstream/green_ios/blob/fecad54bfd1a06e81be9555b68e766acfc415902/gaios/HardwareWallets/LedgerCommands.swift).

I'd also like to have the ability to extend this library with custom commands. Bitcoin Core could use the conservative base library, but other projects might want to extend to implement ColdCard HSM or multisig registration featurest, or Trezor 2FA features.

## Roadmap

- [ ] `enumerate` and `getxpub` for Trezor and ColdCard, testing with HWI's unittests (fork of HWI installed as git submodule to facilitate this).
- [ ] Produce Android and desktop packages on top of this which plug in the relevant transport for those platforms.
- [ ] Demo Android app that can, say, pull an xpub off a ColdCard or a Trezor.
- [ ] Evaluate and decide whether to proceed and attempt to finish the job or back down, like a coward.

## Setup

```
# Clone with git submodules (HWI fork installed as submodule)
$ git clone --recursive git@github.com:justinmoon/hwi-rs.git
$ cd hwi-rs

# Build the project
$ cargo build

# Install HWI project and unittest dependencies
$ ./setup.sh

# Run HWI tests against output of `cargo build`
$ ./test.sh 
```

## Prior Art

### ColdCard

- The Python [ckcc-protocol](https://github.com/Coldcard/ckcc-protocol) library is the only implementation of the ckcc protocol that I'm aware of.

### Trezor

- [Steven Roose has a nice Rust implementation for Trezor USB connections](https://github.com/stevenroose/rust-trezor-api).

### Ledger

- [This library](https://github.com/Zondax/ledger-rs) claims to be a Rust Ledger client, but I couldn't get it working in minimal testing

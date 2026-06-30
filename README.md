# Portable Proton App Runner

Run Windows applications and games directly from your Linux file manager using **Steam's Proton** and **Steam Runtime**, without adding them to your Steam library.

The launcher automatically creates an isolated Proton prefix for each executable (or optionally uses a custom/shared prefix), making it easy to keep applications separated and portable.

---

# Index

- [Introduction](#introduction)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Flags](#flags)
- [How it works](#how-it-works)
- [Debugging](#debugging)
  - [~/.local/bin is not in PATH](#localbin-is-not-in-path)
  - [Proton is not being detected](#proton-is-not-being-detected)
  - [Steam Runtime is not being detected](#steam-runtime-is-not-being-detected)
  - [Installing MangoHud](#installing-mangohud)
  - [Other common problems](#other-common-problems)

---

# Introduction

Portable Proton App Runner allows you to launch any Windows executable (`.exe`) directly from your desktop environment using Steam's Proton.

Instead of invoking Proton directly, the script uses:

- Steam's **Proton**
- Steam's **Linux Runtime (Sniper)**

Using the Steam Runtime helps provide a consistent execution environment across Linux distributions and improves compatibility with many Windows applications.

Features:

- Automatic per-application Proton prefixes
- Optional custom prefixes
- Optional shared prefix
- Optional MangoHud support
- Desktop integration through a `.desktop` file
- Passes all additional arguments directly to the executable

---

# Dependencies
- Steam
- A Proton version installed (GE-Proton or official Proton)
- Steam Linux Runtime (Sniper)
- Mangohud (optional)


---

# Installation

Clone the repository and install it:

```bash
git clone https://github.com/Scratchaker/Portable-Proton-App-Runner.git

mkdir -p ~/.protonrunner
cp Portable-Proton-App-Runner/runWithProton.sh ~/.protonrunner/
chmod +x ~/.protonrunner/runWithProton.sh

mkdir -p ~/.local/bin
ln -s ~/.protonrunner/runWithProton.sh ~/.local/bin/proton

mkdir -p ~/.local/share/applications
cp portable-proton-app-runner/proton-run.desktop ~/.local/share/applications/
```

After installation:

- The launcher script should be located at:

```
~/.protonrunner/runWithProton.sh
```

- A symlink should exist:

```
~/.local/bin/proton
```

- The desktop file should be copied to:

```
~/.local/share/applications/
```

Once installed, most desktop environments will allow opening `.exe` files using **Proton Runner**.

---

# Configuration

The first section of the script contains all configurable environment variables.

```bash
PROTON_ROOT="$HOME/.proton"
STEAM_ROOT="$(realpath "$HOME/.steam/root")"
PROTON_VER="Proton - Experimental"

USE_UNIFIED_PREFIX=0
USE_MANGOHUD=0
```

## PROTON_ROOT

Location where Proton prefixes are stored.

Default:

```
~/.proton
```

---

## STEAM_ROOT

Steam installation directory.

Normally this does not need to be changed.

---

## PROTON_VER

Specifies which installed Proton version should be used.

Example:

```bash
PROTON_VER="GE-Proton10-34"
```

or

```bash
PROTON_VER="Proton Experimental"
```

---

## USE_UNIFIED_PREFIX

Controls prefix behavior.

Value | Description
----- | -----------
0 | One prefix per executable
1 | Shared prefix for all applications

---

## USE_MANGOHUD

Enable MangoHud by default.

```
0 = Disabled
1 = Enabled
```

This can also be overridden using command-line flags.

---

# Usage

Basic usage:

```bash
proton game.exe
```

Custom prefix:

```bash
proton --prefix ~/.proton/mygame game.exe
```

Enable MangoHud:

```bash
proton --mangohud game.exe
```

Disable MangoHud:

```bash
proton --nomangohud game.exe
```

Pass extra arguments:

```bash
proton game.exe --windowed --nosound
```
*Passed arguments must be supported by the game*

---
# Flags

| Flag | Description |
|------|-------------|
| `--prefix PATH` | Use a custom Proton prefix |
| `--prefix=PATH` | Same as above |
| `--mangohud` | Enable MangoHud |
| `--nomangohud` | Disable MangoHud |
| `--help` | Show help |

---

# How it works

When an executable is launched:

1. The script determines which Proton version should be used.
2. A Proton prefix is created (or reused).
3. Steam Runtime is initialized.
4. Required Proton environment variables are exported.
5. Proton launches the executable.
6. Any extra arguments are forwarded unchanged.

---

# Debugging

## ~/.local/bin is not in PATH

Some distributions do not automatically include `~/.local/bin` in your PATH.

Check:

```bash
echo $PATH
```

If the directory is missing, add the following line to your shell configuration.

### Bash

`~/.profile`

or

`~/.bash_profile`

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Zsh

`~/.zprofile`

```bash
export PATH="$HOME/.local/bin:$PATH"
```

After editing the file:

```bash
source ~/.profile
```

or

```bash
source ~/.zprofile
```

or simply log out and back in.

---

## Proton is not being detected

The script searches for the Proton version specified by:

```bash
PROTON_VER
```

If it cannot be found:

- Verify that the version is installed.
- Change `PROTON_VER` to match an installed version.
- Install the desired Proton version from Steam.

To install Proton:

1. Open Steam.
2. Go to **Library**.
3. Search for the Proton version (for example, Proton Experimental).
4. Install it.

For GE-Proton, install it using your preferred Proton-GE installation method.

---

## Steam Runtime is not being detected

The script expects Steam Linux Runtime Sniper to exist.

Usually it is downloaded automatically after launching any Windows game.

If it is missing:

- Launch any Proton game from Steam.
- Steam should automatically download **Steam Linux Runtime - Sniper**.

If it does not:

1. Open Steam.
2. Enable **Tools** in your library filter.
3. Search for:

```
Steam Linux Runtime - Sniper
```

4. Install it manually.

---

## Installing MangoHud

### Ubuntu / Debian

```bash
sudo apt install mangohud
```

### Fedora

```bash
sudo dnf install mangohud
```

### Arch Linux

```bash
sudo pacman -S mangohud
```

### openSUSE

```bash
sudo zypper install mangohud
```

If your distribution does not package MangoHud, install it from the official GitHub releases.

---

## Other common problems

### Steam installed through Flatpak

The script expects a standard Steam installation.

If using the Flatpak version, `STEAM_ROOT` will likely need to be changed.

---

### Executable does not start

Check:

- The executable is not corrupted.
- Proton supports the application.
- The required Visual C++ runtimes are installed.
- The application is compatible with your Proton version.

---

### Wrong working directory

Some applications expect to start from their own directory.

The launcher changes into the executable's directory before launching it.

---

### Prefix issues

Delete the application's Proton prefix and let it be recreated.

By default they are stored in:

```
~/.proton/
```

---

### Missing permissions

Ensure the launcher is executable:

```bash
chmod +x ~/.protonrunner/runWithProton.sh
```

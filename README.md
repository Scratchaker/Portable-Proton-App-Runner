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
- [Troubleshooting](#troubleshooting)
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
- A Proton version (GE-Proton(recommended) or official Proton)
- Steam Linux Runtime (Sniper)
- Mangohud (optional)


---

# Installation

Use the One-liner install script:

```
curl -fsSL https://raw.githubusercontent.com/Scratchaker/Portable-Proton-App-Runner/main/install.sh | bash
```

Once installed, most desktop environments will allow opening `.exe` files using **Proton Runner**.

---

# Configuration

Use the config file located in `~/.config/proton-runner/config.sh`.

```
PROTON_ROOT="$HOME/.proton"
STEAM_ROOT="$(realpath "$HOME/.steam/root")"
PROTON_VER="Proton - Experimental"
STEAM_RUNTIME="$STEAM_ROOT/steamapps/common/SteamLinuxRuntime_sniper/run"
USE_UNIFIED_PREFIX=0
USE_MANGOHUD=0
```

### PROTON_ROOT

Location where Proton prefixes are stored.

Default:

```
~/.proton
```

### STEAM_ROOT

Steam installation directory.

Ususally this does not need to be changed.

### PROTON_VER

Specifies which installed Proton version should be used, it will be found automatically if installed in `STEAM_ROOT`

Example:

```
PROTON_VER="GE-Proton10-34"
```

or

```
PROTON_VER="Proton - Experimental"
```


### USE_UNIFIED_PREFIX

Controls if each executable must have it own prefix.


```
0 = One prefix per executable
1 = Shared prefix for all applications
```

### USE_MANGOHUD

Enable MangoHud by default.

```
0 = Disabled
1 = Enabled
```

***Most configurations can be overridden with cli flags***

---

# Usage

Basic usage:
```
proton-runner game.exe
```

Custom prefix:
```
proton-runner --prefix="~/.proton/mygame" game.exe
```

Custom proton version:
```
proton-runner --proton="GE-Proton10-34" game.exe
```

Force a custom Steam AppID (To take advantage of per-game protonfixes):
```
proton-runner --steamappid=477160 game.exe
```

Enable MangoHud:
```
proton-runner --mangohud game.exe
```

Disable MangoHud:
```
proton-runner --nomangohud game.exe
```

Pass extra arguments to the game:
```
proton-runner game.exe --windowed --nosound
```
*Passed arguments must be supported by the game*

---
# Flags

| Flag | Description |
|------|-------------|
| `--prefix="~/path/to/prefix"` | Set custom prefix |
| `--proton="Proton version"` | Use custom proton version |
| `--steamappid=appid`  | Force the use of a specific per-game protonfix |
| `--mangohud` | Enable MangoHud |
| `--nomangohud` | Disable MangoHud |
| `--help` `-h` | Show help |
| `--version` `-v` | Show script version

---

# How it works

When an executable is launched:

1. The script determines which Proton version should be used.
2. A Proton prefix is created (or reused).
3. Steam Runtime is initialized.
4. Required Proton environment variables are exported.
5. Proton launches the executable passing extra arguments to the game.

---

# Troubleshooting

## ~/.local/bin is not in PATH

Some distributions do not automatically include `~/.local/bin` in your $PATH.

**Some distributions only include it if the directory exists at login. In this cases a reboot or logout+login should do the trick.*

Check:

```
echo $PATH
```

If the directory is missing, add the following line to your shell configuration.

### Bash

`~/.profile`

or

`~/.bash_profile`

```
export PATH="$HOME/.local/bin:$PATH"
```

### Zsh

`~/.zprofile`

```
export PATH="$HOME/.local/bin:$PATH"
```

After editing the file(s) log out and back in.

---

## Proton is not being detected

The script searches for the Proton version specified by:

```
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

For GE-Proton(recommended), install it using your preferred Proton-GE installation method (ProtonPlus, ProtonUp-Qt or manual installation).

---

## Steam Runtime is not being detected

The script expects Steam Linux Runtime Sniper to exist.

Usually it is downloaded automatically after launching any Windows game.

If it is missing:

- Launch any Proton game from Steam.
- Steam should automatically download **Steam Linux Runtime - Sniper**.

Or install it manually:

1. Open Steam.
2. Enable **Tools** in your library filter.
3. Search for `Steam Linux Runtime - Sniper`
4. Install it manually.

---

## Installing MangoHud

### Ubuntu / Debian

```
sudo apt install mangohud
```

### Fedora

```
sudo dnf install mangohud
```

### Arch Linux

```
sudo pacman -S mangohud
```

### openSUSE

```
sudo zypper install mangohud
```

If your distribution does not package MangoHud, install it from [the official GitHub releases](https://github.com/flightlessmango/MangoHud).

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

### Prefix issues

Delete the application's Proton prefix and let it be recreated.

By default they are stored in:

```
~/.proton/
```

---


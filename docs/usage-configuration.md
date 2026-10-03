# Usage

**Basic usage:**
```
proton-runner game.exe
```

**Custom prefix:**
```
proton-runner --prefix="~/.proton/mygame" game.exe
```
```
CUSTOM_PREFIX="~/.proton/mygame" proton-runner game.exe
```
**Custom proton version:**
```
proton-runner --proton="GE-Proton10-34" game.exe
```
```
PROTON_VER="GE-Proton10-34" proton-runner game.exe
```
**Force a custom Steam AppID (To take advantage of per-game protonfixes):**
```
proton-runner --steamappid=477160 game.exe
```
```
APPID=477160 proton-runner game.exe
```
**Enable MangoHud:**
```
proton-runner --mangohud game.exe
```
```
MANGOHUD=1 proton-runner game.exe
```
**Disable MangoHud:**
```
proton-runner --nomangohud game.exe
```
```
MANGOHUD=0 proton-runner game.exe
```
**Pass extra arguments to the game:**
```
proton-runner game.exe --windowed --nosound
```
*Passed arguments must be supported by the game*

---

# Configuration

Use the config file located in `~/.config/proton-runner/config.sh`.

```
PROTON_ROOT="$HOME/.proton"
STEAM_ROOT="$(realpath "$HOME/.steam/root")"
PROTON_VER="Proton - Experimental"
ADDITIONAL_PROTON_DIRS=("/usr/share/steam")
STEAM_RUNTIME="$STEAM_ROOT/steamapps/common/SteamLinuxRuntime_sniper/run"
USE_UNIFIED_PREFIX=0
MANGOHUD=0
```

| Config | Description | Default |
|---|---|---|
| `PROTON_ROOT` | Location where Proton prefixes are stored. | `"$HOME/.proton"` |
| `STEAM_ROOT` | Steam installation directory. | `"$HOME/.steam/root"` Usually a symlink(resolved with `realpath`) |
| `PROTON_VER` | Proton version to use, must be in `STEAM_ROOT` or `ADDITIONAL_PROTON_DIRS`. | `"Proton - Experimental"` |
| `ADDITIONAL_PROTON_DIRS` | Alternative directories where proton may be installed, use bash list syntax (`("/usr/share/steam" "/example/dir")`). | `("/usr/share/steam")` |
| `USE_UNIFIED_PREFIX` | Use a single prefix for all games. (`0` or `1`) | `0` |
| `MANGOHUD` | Use the MangoHud performance overlay. (`0` or `1`) | `0` |

**Most configurations can be overridden with cli flags and env vars*

---

# Summary

| Flag                          | ENV var                            | Description                                    |
|-------------------------------|------------------------------------|------------------------------------------------|
| `--prefix="~/path/to/prefix"` | `CUSTOM_PREFIX="~/path/to/prefix"` | Set custom prefix                              |
| `--proton="Proton version"`   | `PROTON_VER="Proton version"`      | Use custom proton version                      |
| `--steamappid=appid`          | `APPID=appid`                      | Select a per-game Protonfix                    |
| `--mangohud`                  | `MANGOHUD=1`                       | Enable MangoHud                                |
| `--nomangohud`                | `MANGOHUD=0`                       | Disable MangoHud                               |
| `--help` `-h`                 | -                                  | Print help message                             |
| `--man`                       | -                                  | Show manual page                               |
| `--version` `-v`              | -                                  | Show script version                            |
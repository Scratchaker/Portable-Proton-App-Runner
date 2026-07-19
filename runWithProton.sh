#!/usr/bin/env bash

# Adapted from: https://gist.github.com/shmup/4e7050d50e1db2e9fc4071bf31efa934
# Original author: Jared Miller (https://gist.github.com/shmup)

# This script launches a Windows executable using Proton within a Linux environment.
# It requires at least one argument: the path to the executable to run
# Extra agruments will be passed to the executable.
# It sets up a separate Proton prefix for each executable to avoid conflicts.
# Usage: proton <path-to-executable>


# Fallback env vars
PROTON_ROOT="$HOME/.proton"
STEAM_ROOT="$(realpath "$HOME/.steam/root")"
PROTON_VER="Proton - Experimental"
STEAM_RUNTIME="$STEAM_ROOT/steamapps/common/SteamLinuxRuntime_sniper/run"
USE_UNIFIED_PREFIX=0
USE_MANGOHUD=0

# Get config
CFG_DIR="$HOME/.config/proton-runner/config.sh"
if [[ -f $CFG_DIR ]]; then
    source $CFG_DIR
fi

# Compute full proton directory
PROTON_DIR="$(find "$STEAM_ROOT" -wholename '*/proton' | grep --color=never -F "$PROTON_VER" | head -1)"

# Parse arguments
CUSTOM_PREFIX=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix=*)
            CUSTOM_PREFIX="${1#--prefix=}"
            CUSTOM_PREFIX="${CUSTOM_PREFIX/#\~/$HOME}"
            shift
            ;;
        --prefix)
            CUSTOM_PREFIX="$2"
            CUSTOM_PREFIX="${CUSTOM_PREFIX/#\~/$HOME}"
            shift 2
            ;;
        --proton=*)
            PROTON_VER="${1#--proton=}"
            PROTON_DIR="$(find "$STEAM_ROOT" -wholename '*/proton' | grep --color=never -F "$PROTON_VER" | head -1)"
            shift
            ;;
        --proton)
            PROTON_VER="$2"
            PROTON_DIR="$(find "$STEAM_ROOT" -wholename '*/proton' | grep --color=never -F "$PROTON_VER" | head -1)"
            shift 2
            ;;
        --mangohud)
            USE_MANGOHUD=1
            shift
            ;;
        --nomangohud)
            USE_MANGOHUD=0
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--prefix=PATH] [--proton=VERSION] [--mangohud | --nomangohud] <executable> [args...]"
            echo ""
            echo "Arguments:"
            echo "  <executable>          Path to the .exe to run (required)"
            echo "  [args...]             Extra arguments passed to the executable"
            echo ""
            echo "Options:"
            echo "  --prefix=PATH         Override the Wine prefix directory"
            echo "                        Default: ~/.proton/<exe-name>/"
            echo "  --proton=VERSION      Override the Proton version to use"
            echo "                        Default: $PROTON_VER"
            echo "  --mangohud            Enable MangoHud overlay"
            echo "  --nomangohud          Disable MangoHud overlay (default)"
            echo ""
            echo "Examples:"
            echo "  proton ~/games/MyGame/game.exe"
            echo "  proton --prefix=~/.proton/mygame --mangohud ~/games/MyGame/game.exe"
            echo "  proton --proton=GE-Proton9-27 ~/games/MyGame/game.exe"
            echo "  proton ~/games/MyGame/game.exe --windowed --nosound"
            exit 0
            ;;
        --version|-v)
            echo "Portable-Proton-App-Runner version 1.0"
            exit 0
            ;;
        -*)
            echo "Error: Invalid option" >&2
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ ${#POSITIONAL_ARGS[@]} -lt 1 ]]; then
    echo "Usage: $0 [--prefix=/path/to/prefix] <executable-path> [args...]"
    exit 1
fi

# Restore positional args
set -- "${POSITIONAL_ARGS[@]}"


# Check if proton version exists
if [[ -z "$PROTON_DIR" ]]; then
    echo "Error: could not find Proton version '$PROTON_VER' under $STEAM_ROOT" >&2
    exit 1
fi

# Prefix management
if [[ -n "$CUSTOM_PREFIX" ]]; then
    GAME_ROOT="$(dirname "$1")"
    GAME="$(basename "$1" ".exe" | tr ' ' '_')"
    cd "$GAME_ROOT" || true  # non-fatal, not all exes need cwd
    mkdir -p "$CUSTOM_PREFIX"
    export STEAM_COMPAT_DATA_PATH="$CUSTOM_PREFIX"
else
    case $USE_UNIFIED_PREFIX in
        0)
            # Create game prefix
            GAME_ROOT="$(dirname "$1")"
            GAME="$(basename "$1" ".exe" | tr ' ' '_')"
            cd "$GAME_ROOT" || exit
            mkdir -p "$PROTON_ROOT/$GAME"
            export STEAM_COMPAT_DATA_PATH="$PROTON_ROOT/$GAME"
            ;;
        1)
            # Use one prefix for everything
            GAME_ROOT="$(dirname "$1")"
            [[ -d  "$PROTON_ROOT/protonprefix" ]] || mkdir -p "$PROTON_ROOT/protonprefix"
            export STEAM_COMPAT_DATA_PATH="$PROTON_ROOT/protonprefix"
            ;;
        *)
            echo "Unknown config." >&2
            exit 1
            ;;
    esac
fi
# Mangohud
case $USE_MANGOHUD in
    0)
        # Disabled Mangohud
        export MANGOHUD=0
        ;;
    1)
        # Enabled Mangohud
        export MANGOHUD=1
        ;;
    *)
        echo "Unknown config." >&2
        exit 1
        ;;
esac

# Runtime env vars
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_ROOT"
export PROTON_LOG=0
export SteamAppId=0
export SteamGameId=0
export STEAM_COMPAT_APP_ID=0

# Run game
if [[ -n "$STEAM_RUNTIME" ]]; then
    "$STEAM_RUNTIME" -- "$PROTON_DIR" waitforexitandrun "$@"
else
    "$PROTON_DIR" waitforexitandrun "$@"
fi


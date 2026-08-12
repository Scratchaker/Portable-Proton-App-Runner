#!/usr/bin/env bash

# Idea from: https://gist.github.com/shmup/4e7050d50e1db2e9fc4071bf31efa934
# Original author: Jared Miller (https://gist.github.com/shmup)

# Store the path to the script
SELF="$(readlink -f "$0")"
# Save current environment
curenv=$(declare -p -x)
# Export all config env vars
set -o allexport
# Fallback env vars
PROTON_ROOT="$HOME/.proton"
STEAM_ROOT="$(realpath "$HOME/.steam/root")"
PROTON_VER="Proton - Experimental"
ADDITIONAL_PROTON_DIRS=("/usr/share/steam")
STEAM_RUNTIME="$STEAM_ROOT/steamapps/common/SteamLinuxRuntime_sniper/run"
USE_UNIFIED_PREFIX=0
MANGOHUD=0
# Get user config
CFG_DIR="$HOME/.config/proton-runner/config.sh"
if [[ -f "$CFG_DIR" ]]; then
    source "$CFG_DIR"
fi
# Stop exporting all config env vars
set +o allexport
# Reapply saved environment
eval "$curenv"

# Check config
if [[ ! "$USE_UNIFIED_PREFIX" =~ ^[01]$ ]] || [[ ! "$MANGOHUD" =~ ^[01]$ ]]; then
    echo -e "\e[31mError: Unknown config.\e[0m" >&2
    exit 1
fi

# Define script version
VER="1.1.1"

# Parse arguments
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --prefix=*)
            CUSTOM_PREFIX="${1#--prefix=}"
            shift
            ;;
        --prefix)
            CUSTOM_PREFIX="$2"
            shift 2
            ;;
        --proton=*)
            PROTON_VER="${1#--proton=}"
            shift
            ;;
        --proton)
            PROTON_VER="$2"
            shift 2
            ;;
        --steamappid=*)
            APPID="${1#--steamappid=}"
            if [[ ! "$APPID" =~ ^[1-9][0-9]*$ ]]; then
                echo -e "\e[31mError: Invalid AppID format: $APPID\e[0m" >&2
                exit 6
            fi
            shift
            ;;
        --steamappid)
            APPID="$2"
            if [[ ! "$APPID" =~ ^[1-9][0-9]*$ ]]; then
                echo -e "\e[31mError: Invalid AppID format: $APPID\e[0m" >&2
                exit 6
            fi
            shift 2
            ;;
        --mangohud)
            export MANGOHUD=1
            shift
            ;;
        --nomangohud)
            export MANGOHUD=0
            shift
            ;;
        --help|-h)
            if [[ $USE_UNIFIED_PREFIX -eq 0 ]]; then
                DISPLAY_PREFIX_PATH="$PROTON_ROOT/<exe-name>"
            else
                DISPLAY_PREFIX_PATH="$PROTON_ROOT/protonprefix"
            fi
            if [[ $MANGOHUD -eq 0 ]]; then
                MH_ENABLED=""
                MH_DISABLED="(default)"
            else
                MH_ENABLED="(default)"
                MH_DISABLED=""
            fi
            echo "Portable Proton App Runner                 Version: $VER"
            echo "Usage: $0 [--prefix=PATH] [--proton=VERSION] [--mangohud | --nomangohud] <executable> [args...]"
            echo ""
            echo "Arguments:"
            echo "  <executable>          Path to the .exe to run (required)"
            echo "  [args...]             Extra arguments passed to the executable"
            echo ""
            echo "Options:"
            echo "  --prefix=PATH         Override the Wine prefix directory"
            echo "                        Default: $DISPLAY_PREFIX_PATH"
            echo "  --proton=VERSION      Override the Proton version to use"
            echo "                        Default: $PROTON_VER"
            echo "  --mangohud            Enable MangoHud overlay $MH_ENABLED"
            echo "  --nomangohud          Disable MangoHud overlay $MH_DISABLED"
            echo ""
            echo "Examples:"
            echo "  proton ~/games/MyGame/mygame.exe"
            echo "  proton --prefix=\"~/.proton/mygame\" --mangohud ~/games/MyGame/mygame.exe"
            echo "  proton --proton=\"GE-Proton9-27\" ~/games/MyGame/mygame.exe"
            echo "  proton ~/games/MyGame/mygame.exe --windowed --nosound"
            exit 0
            ;;
        --version|-v)
            echo "Portable Proton App Runner version $VER"
            exit 0
            ;;
        -*)
            echo -e "\e[31mError: Invalid option: $1\e[0m" >&2
            exit 3
            ;;
        *)
            POSITIONAL_ARGS+=("$@")
            break
            ;;
    esac
done

if [[ ${#POSITIONAL_ARGS[@]} -lt 1 ]]; then
    echo -e "\e[31mError: You must provide at least one argument.\e[0m" >&2
    exit 2
fi

# Restore positional args
set -- "${POSITIONAL_ARGS[@]}"


# Compute full proton directory
PROTON_DIR="$(find "${ADDITIONAL_PROTON_DIRS[@]}" "$STEAM_ROOT" -wholename '*/proton' 2>/dev/null | grep --color=never -F "$PROTON_VER" | head -1)"

# Check if proton version exists
if [[ -z "$PROTON_DIR" ]]; then
    echo -e "\e[31mError: could not find Proton version '$PROTON_VER' under $STEAM_ROOT\e[0m" >&2
    exit 4
fi

# Prefix management
if [[ -n "$CUSTOM_PREFIX" ]]; then
    CUSTOM_PREFIX="${CUSTOM_PREFIX/#\~/$HOME}"
    GAME_ROOT="$(dirname "$1")"
    cd "$GAME_ROOT" || exit 7
    mkdir -p "$CUSTOM_PREFIX"
    export STEAM_COMPAT_DATA_PATH="$CUSTOM_PREFIX"
else
    case $USE_UNIFIED_PREFIX in
        0)
            # Create game prefix
            GAME_ROOT="$(dirname "$1")"
            GAME="$(basename "$1" ".exe" | tr ' ' '_')"
            cd "$GAME_ROOT" || exit 7
            mkdir -p "$PROTON_ROOT/$GAME"
            export STEAM_COMPAT_DATA_PATH="$PROTON_ROOT/$GAME"
            ;;
        1)
            # Use one prefix for everything
            GAME_ROOT="$(dirname "$1")"
            cd "$GAME_ROOT" || exit 7
            [[ -d  "$PROTON_ROOT/protonprefix" ]] || mkdir -p "$PROTON_ROOT/protonprefix"
            export STEAM_COMPAT_DATA_PATH="$PROTON_ROOT/protonprefix"
            ;;
    esac
fi

# Runtime env vars
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_ROOT"
export PROTON_LOG=0

# AppID
if [[ -z "$APPID" ]]; then
    APPID=0
fi
export SteamAppId="$APPID"
export SteamGameId="$APPID"
export STEAM_COMPAT_APP_ID="$APPID"

# Check if steam runtime exists
if [[ -n "$STEAM_RUNTIME" && ! -x "$STEAM_RUNTIME" ]]; then
    echo -e "\e[31mError: Steam Runtime not found at $STEAM_RUNTIME\e[0m" >&2
    exit 5
fi

# Parse proton created desktop files and add them to the applications directory
create_shortcuts() {
    local shortcuts_src="$STEAM_COMPAT_DATA_PATH/pfx/drive_c/proton_shortcuts"
    local dest_dir="$HOME/.local/share/applications/proton-runner"
    [[ -d "$shortcuts_src" ]] || return 0
    mkdir -p "$dest_dir"

    local stub name icon wmclass exec_line slug out
    local size_dir candidate size_name width best_size icon_path
    for stub in "$shortcuts_src"/*.desktop; do
        [[ -e "$stub" ]] || continue

        name=$(grep -m1 '^Name=' "$stub" | cut -d= -f2-)
        icon=$(grep -m1 '^Icon=' "$stub" | cut -d= -f2-)
        wmclass=$(grep -m1 '^StartupWMClass=' "$stub" | cut -d= -f2-)
        exec_line=$(grep -m1 '^Exec=' "$stub" | cut -d= -f2-)

        # find the highest resolution copy of this icon, in place
        icon_path=""
        best_size=0
        for size_dir in "$shortcuts_src"/icons/*/apps; do
            [[ -d "$size_dir" ]] || continue
            candidate="$size_dir/$icon.png"
            [[ -e "$candidate" ]] || continue
            size_name=$(basename "$(dirname "$size_dir")")
            width="${size_name%%x*}"
            [[ "$width" =~ ^[0-9]+$ ]] || continue
            if (( width > best_size )); then
                best_size=$width
                icon_path="$candidate"
            fi
        done

        slug=$(echo "$name" | tr -c 'a-zA-Z0-9' '_')
        out="$dest_dir/${slug}.desktop"
        echo "Writing: $out"
        cat > "$out" <<EOF
[Desktop Entry]
Type=Application
Name=$name
Icon=${icon_path:-$icon}
Exec=env CUSTOM_PREFIX="$STEAM_COMPAT_DATA_PATH" PROTON_VER="$PROTON_VER" APPID=$APPID $SELF $exec_line
StartupNotify=true
StartupWMClass=$wmclass
Categories=Game;
EOF
    done

    update-desktop-database "$dest_dir" 2>/dev/null || true
    kbuildsycoca6 --noincremental 2>/dev/null || kbuildsycoca5 --noincremental 2>/dev/null || true

}

# Mangohud
LAUNCH_PREFIX=()
if [[ "$MANGOHUD" -eq 1 ]]; then
    if command -v mangohud >/dev/null 2>&1; then
        LAUNCH_PREFIX=(mangohud)
    else
        echo -e "\e[31mError: MANGOHUD=1 but 'mangohud' binary not found in PATH.\e[0m" >&2
        exit 8
    fi
fi

# Run game
if [[ -n "$STEAM_RUNTIME" ]]; then
    "${LAUNCH_PREFIX[@]}" "$STEAM_RUNTIME" -- "$PROTON_DIR" waitforexitandrun "$@"
else
    "${LAUNCH_PREFIX[@]}" "$PROTON_DIR" waitforexitandrun "$@"
fi

create_shortcuts

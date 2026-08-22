#!/usr/bin/env bash

set -euo pipefail

installerDir="/tmp/portable-proton-app-runner"
installDir="$HOME/.local/bin"
applicationDir="$HOME/.local/share/applications"
configDir="$HOME/.config/proton-runner"

cleanup() {
    rm -rf "$installerDir"
}

trap cleanup EXIT

printf '\e[34mDownloading content...\e[0m\n'

rm -rf "$installerDir"
mkdir -p "$installerDir"

git clone https://github.com/Scratchaker/Portable-Proton-App-Runner.git \
    "$installerDir/Portable-Proton-App-Runner"

cd "$installerDir/Portable-Proton-App-Runner"

printf '\e[34mCopying files...\e[0m\n'

mkdir -p "$installDir"
cp runWithProton.sh "$installDir/proton-runner"
chmod +x "$installDir/proton-runner"

mkdir -p "$applicationDir"
cp proton-run.desktop "$applicationDir/proton-run.desktop"

if [[ ! -f "$configDir/config.sh" ]]; then
    mkdir -p "$configDir"
    cp config.sh "$configDir/config.sh"
fi

printf '\e[34mCleaning up...\e[0m\n'
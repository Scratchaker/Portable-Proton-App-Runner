#!/usr/bin/env bash

# Exit on errors, unset variables, and pipeline failures
set -euo pipefail

# Set installation paths
installerDir="/tmp/portable-proton-app-runner"
installDir="$HOME/.local/bin"
applicationDir="$HOME/.local/share/applications"
configDir="$HOME/.config/proton-runner"

# Remove the temporary installer directory
cleanup() {
    echo -e "\e[34mCleaning up...\e[0m"
    rm -rf "$installerDir"
}

# Always clean up when the script exits
trap cleanup EXIT

# Set up installer working directory
echo -e "\e[34mDownloading content...\e[0m"
rm -rf "$installerDir"
mkdir -p "$installerDir"
cd "$installerDir"

# Download the repository
git clone https://github.com/Scratchaker/Portable-Proton-App-Runner.git
cd Portable-Proton-App-Runner

# Copy files to their installation locations
echo -e "\e[34mCopying files...\e[0m"

# Main script
mkdir -p "$installDir"
cp runWithProton.sh "$installDir/proton-runner"
chmod +x "$installDir/proton-runner"

# Desktop launcher
mkdir -p "$applicationDir"
cp proton-run.desktop "$applicationDir/proton-run.desktop"

# Config file
# Don't overwrite an existing configuration
if [[ ! -f "$configDir/config.sh" ]]; then
    mkdir -p "$configDir"
    cp config.sh "$configDir/config.sh"
fi
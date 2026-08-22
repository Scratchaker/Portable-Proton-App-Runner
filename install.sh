#!/usr/bin/env bash

# Exit if something fails
set -e

# Set up installer working directory
echo -e "\e[34mDownloading content...\e[0m"
mkdir -p /tmp/portable-proton-app-runner
cd /tmp/portable-proton-app-runner
git clone https://github.com/Scratchaker/Portable-Proton-App-Runner.git
cd Portable-Proton-App-Runner

# Copy files
echo -e "\e[34mCopying files...\e[0m"
# Main script
mkdir -p "$HOME/.local/bin"
cp runWithProton.sh "$HOME/.local/bin/proton-runner"
chmod +x "$HOME/.local/bin/proton-runner"
# Desktop launcher
mkdir -p "$HOME/.local/share/applications"
cp proton-run.desktop "$HOME/.local/share/applications/proton-run.desktop"
# Config file
if [[ ! -f "$HOME/.config/proton-runner/config.sh" ]]; then
    mkdir -p "$HOME/.config/proton-runner"
    cp config.sh "$HOME/.config/proton-runner/config.sh"
fi

# Clean up
echo -e "\e[34mCleaning up..\e[0m"
cd /tmp
rm -rf /tmp/portable-proton-app-runner

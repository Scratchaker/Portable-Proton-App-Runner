#!/bin/bash

# Exit on errors, unset variables, and pipeline failures
set -euo pipefail

# Make case statements case-insensitive
shopt -s nocasematch

# Set installation paths
scriptFile="$HOME/.local/bin/proton-runner"
applicationFile="$HOME/.local/share/applications/proton-run.desktop"
gamesLauncherDir="$HOME/.local/share/applications/proton-runner"
configFileDir="$HOME/.config/proton-runner"

# Remove installation files
echo -e "\e[34mUninstalling Portable Proton App Runner...\e[0m"

# Main script
echo -e "\e[34mDeleting main script...\e[0m"
rm -f "$scriptFile"

# Applications launcher
echo -e "\e[34mDeleting applications launcher...\e[0m"
rm -f "$applicationFile"

# Installed game launchers
read -r -p "Remove game launchers [Y/n]: " ans
case "$ans" in
    n|no)
        echo -e "\e[34mKeeping installed game launchers (They will not work until you install me back!)...\e[0m"
        ;;
    *)
        echo -e "\e[34mDeleting installed game launchers...\e[0m"
        rm -rf "$gamesLauncherDir"
        ;;
esac

# Configuration file
read -r -p "Remove configuration file [y/N]: " ans
case "$ans" in
    y|yes)
        echo -e "\e[34mDeleting configuration file...\e[0m"
        rm -rf "$configFileDir"
        ;;
    *)
        echo -e "\e[34mKeeping configuration file...\e[0m"
        ;;
esac

echo -e "\e[34mDone\e[0m"

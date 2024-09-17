#!/bin/bash

set -euo pipefail

# Function: Print error message and exit
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Usage check
if [ "$#" -ne 0 ]; then
    echo "Usage: $0" >&2
    exit 1
fi

# Command name
COMMAND_NAME="mkdevdir"

# Target directory for the command
TARGET_DIR="/usr/local/bin"

# Directory where the icon file is stored
ICON_DIR="/usr/local/share/mkdevdir_assets"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Attempting to use sudo..." >&2
    exec sudo "$0" "$@"
fi

# Check for required commands
for cmd in rm; do
    if ! command -v "$cmd" &> /dev/null; then
        error_exit "Required command '$cmd' is not available. Please install it and try again."
    fi
done

# Remove the script file from the target directory
SCRIPT_PATH="$TARGET_DIR/$COMMAND_NAME"
if [ -f "$SCRIPT_PATH" ]; then
    echo "Removing script '$SCRIPT_PATH'..."
    if ! rm "$SCRIPT_PATH"; then
        error_exit "Failed to remove script file '$SCRIPT_PATH'."
    fi
    echo "Removed script: '$SCRIPT_PATH'."
else
    echo "Warning: Script file '$SCRIPT_PATH' not found." >&2
fi

# Remove the icon directory
if [ -d "$ICON_DIR" ]; then
    echo "Removing icon directory '$ICON_DIR'..."
    if ! rm -rf "$ICON_DIR"; then
        error_exit "Failed to remove icon directory '$ICON_DIR'."
    fi
    echo "Removed icon directory: '$ICON_DIR'."
else
    echo "Warning: Icon directory '$ICON_DIR' not found." >&2
fi

echo "Uninstallation completed. The '$COMMAND_NAME' command has been removed from your system."
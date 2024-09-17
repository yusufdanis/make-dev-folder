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

# Directory where the script and icon file are located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory for the command
TARGET_DIR="/usr/local/bin"

# Directory for storing the icon file
ICON_DIR="/usr/local/share/mkdevdir_assets"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Attempting to use sudo..." >&2
    exec sudo "$0" "$@"
fi

# Check for required commands
for cmd in cp chmod mkdir command; do
    if ! command -v "$cmd" &> /dev/null; then
        error_exit "Required command '$cmd' is not available. Please install it and try again."
    fi
done

# Copy the script file to the target directory
echo "Copying '$SCRIPT_DIR/mkdevdir.sh' to '$TARGET_DIR/$COMMAND_NAME'..."
if ! cp "$SCRIPT_DIR/mkdevdir.sh" "$TARGET_DIR/$COMMAND_NAME"; then
    error_exit "Failed to copy script file to '$TARGET_DIR'."
fi

# Ensure the script is executable
echo "Setting execute permissions for '$TARGET_DIR/$COMMAND_NAME'..."
if ! chmod +x "$TARGET_DIR/$COMMAND_NAME"; then
    error_exit "Failed to set execute permissions for '$TARGET_DIR/$COMMAND_NAME'."
fi

# Create the icon directory if it doesn't exist
echo "Creating icon directory '$ICON_DIR'..."
if ! mkdir -p "$ICON_DIR"; then
    error_exit "Failed to create directory '$ICON_DIR'."
fi

# Copy the icon file to the icon directory
ICON_SOURCE="$SCRIPT_DIR/assets/Icon"$'\r'
ICON_DESTINATION="$ICON_DIR/Icon"$'\r'

echo "Copying icon to '$ICON_DESTINATION'..."
if ! cp "$ICON_SOURCE" "$ICON_DESTINATION"; then
    error_exit "Failed to copy icon file to '$ICON_DIR'."
fi

# Verify if the icon file was copied successfully
if [ ! -f "$ICON_DESTINATION" ]; then
    error_exit "Icon file was not copied successfully to '$ICON_DIR'."
fi

# Check if the command is available in the PATH
if ! command -v "$COMMAND_NAME" &> /dev/null; then
    echo "Warning: The command '$COMMAND_NAME' may not be in your PATH." >&2
    echo "You may need to add '$TARGET_DIR' to your PATH or restart your terminal." >&2
fi

echo "Installation completed successfully. You can now use '$COMMAND_NAME' to create a new directory with a developer icon or change an existing directory's icon."
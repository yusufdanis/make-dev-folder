#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <command_name>"
    exit 1
fi

# The command name specified by the user
COMMAND_NAME="$1"

# Directory where the script and icon file are located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory
TARGET_DIR="/usr/local/bin"

# Copy the script file to the target directory
if ! cp "$SCRIPT_DIR/make_dev_folder.sh" "$TARGET_DIR/$COMMAND_NAME"; then
    echo "Error: Failed to copy script file to $TARGET_DIR" >&2
    exit 1
fi

# Ensure the script is executable
if ! chmod +x "$TARGET_DIR/$COMMAND_NAME"; then
    echo "Error: Failed to make the script executable" >&2
    exit 1
fi

# Directory for storing the icon file
ICON_DIR="/usr/local/share/make_dev_folder_assets"

# Create the icon directory if it doesn't exist
if ! mkdir -p "$ICON_DIR"; then
    echo "Error: Failed to create directory $ICON_DIR" >&2
    exit 1
fi

# Copy the icon file to the icon directory
if ! cp "$SCRIPT_DIR/assets/Icon"$'\r' "$ICON_DIR/Icon"$'\r'; then
    echo "Error: Failed to copy icon file to $ICON_DIR" >&2
    exit 1
fi

# Verify if the icon file was copied successfully
if [ ! -f "$ICON_DIR/Icon"$'\r' ]; then
    echo "Error: Icon file was not copied successfully to $ICON_DIR" >&2
    exit 1
fi

# Check if the command is now available in the PATH
if ! command -v "$COMMAND_NAME" &> /dev/null; then
    echo "Warning: The command '$COMMAND_NAME' may not be in the system PATH." >&2
    echo "You may need to add $TARGET_DIR to your PATH or restart your terminal." >&2
fi

echo "Setup completed. Use '$COMMAND_NAME' to create a new folder with a developer icon or change an existing folder's icon."
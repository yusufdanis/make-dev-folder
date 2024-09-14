#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <command_name>"
    exit 1
fi

# The command name specified by the user
COMMAND_NAME="$1"

# Target directory
TARGET_DIR="/usr/local/bin"

# Remove the script file from the target directory
if [ -f "$TARGET_DIR/$COMMAND_NAME" ]; then
    if ! rm "$TARGET_DIR/$COMMAND_NAME"; then
        echo "Error: Failed to remove script file from $TARGET_DIR" >&2
        exit 1
    fi
    echo "Removed script: $TARGET_DIR/$COMMAND_NAME"
else
    echo "Warning: Script file not found in $TARGET_DIR" >&2
fi

# Directory for storing the icon file
ICON_DIR="/usr/local/share/make_dev_folder_assets"

# Remove the entire icon directory
if [ -d "$ICON_DIR" ]; then
    if ! rm -rf "$ICON_DIR"; then
        echo "Error: Failed to remove icon directory $ICON_DIR" >&2
        exit 1
    fi
    echo "Removed icon directory: $ICON_DIR"
else
    echo "Warning: Icon directory not found: $ICON_DIR" >&2
fi

echo "Uninstallation completed. The '$COMMAND_NAME' command has been removed."
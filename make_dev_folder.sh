#!/bin/bash

make_dev_folder() {
    local target_folder="$1"
    local custom_icon_file="$(dirname "$0")/assets/Icon"$'\r'
    # If installed system wide, use the system wide icon file
    local system_wide_icon_file="/usr/local/share/make_dev_folder_assets/Icon"$'\r'

    # Determine which icon file to use based on script location
    local icon_file_to_use="$custom_icon_file"
    if [[ "$0" == "/usr/local/bin/"* ]]; then
        icon_file_to_use="$system_wide_icon_file"
    fi

    # Create target folder if it doesn't exist
    if ! mkdir -p "$target_folder"; then
        echo "Error: Failed to create target folder: $target_folder" >&2
        exit 1
    fi

    # Check if the icon file exists
    if [ ! -f "$icon_file_to_use" ]; then
        echo "Error: Developer icon file not found: $icon_file_to_use" >&2
        exit 1
    fi

    # Set the target icon file path
    local target_icon="$target_folder/Icon"$'\r'

    # Remove existing Icon file in the target folder if it exists
    if [ -f "$target_icon" ] && ! rm "$target_icon"; then
        echo "Error: Failed to remove existing icon file: $target_icon" >&2
        exit 1
    fi

    # Create new Icon file and set attributes
    if cp "$icon_file_to_use" "$target_icon"; then
        if ! SetFile -a C "$target_folder"; then
            echo "Warning: Failed to set custom icon attribute on folder" >&2
        fi
        if ! SetFile -a V "$target_icon"; then
            echo "Warning: Failed to set invisible attribute on icon file" >&2
        fi
    else
        echo "Error: Failed to copy icon file" >&2
        exit 1
    fi

    # Verify if the icon was set correctly
    if [ ! -f "$target_icon" ]; then
        echo "Error: Icon file was not created successfully" >&2
        exit 1
    fi

    echo "Process completed: $(basename "$target_folder")"
}

# Usage check and execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <target_folder_path>" >&2
    exit 1
fi

# Convert relative path to absolute path
full_path="$(cd "$(dirname "$1")" && pwd -P)/$(basename "$1")"

make_dev_folder "$full_path"
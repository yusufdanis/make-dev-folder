#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_ICON_FILE="${SCRIPT_DIR}/assets/Icon"$'\r'
SYSTEM_WIDE_ICON_FILE="/usr/local/share/mkdevdir_assets/Icon"$'\r'

log_error() {
    echo "Error: $1" >&2
}

log_warning() {
    echo "Warning: $1" >&2
}

set_icon_attributes() {
    local target_dir="$1"
    local target_icon="$2"

    if ! command -v SetFile &> /dev/null; then
        log_error "SetFile command not found. Make sure Xcode Command Line Tools are installed."
        return 1
    fi

    if ! SetFile -a C "$target_dir"; then
        log_error "Failed to set custom icon attribute on directory: $target_dir"
        return 1
    fi

    if ! SetFile -a V "$target_icon"; then
        log_error "Failed to set invisible attribute on icon file: $target_icon"
        return 1
    fi

    return 0
}

mkdevdir() {
    local target_dir="$1"
    local custom_icon_file="$CUSTOM_ICON_FILE"
    # If installed system wide, use the system wide icon file
    local system_wide_icon_file="$SYSTEM_WIDE_ICON_FILE"

    # Determine which icon file to use based on script location
    local icon_file_to_use="$custom_icon_file"
    if [[ "$0" == "/usr/local/bin/"* ]]; then
        icon_file_to_use="$system_wide_icon_file"
    fi

    # Create target directory if it doesn't exist
    if ! mkdir -p "$target_dir"; then
        log_error "Failed to create target directory: $target_dir"
        exit 1
    fi

    # Check if the icon file exists
    if [ ! -f "$icon_file_to_use" ]; then
        log_error "Developer icon file not found: $icon_file_to_use"
        exit 1
    fi

    # Set the target icon file path
    local target_icon="${target_dir}/Icon"$'\r'

    # Remove existing Icon file in the target directory if it exists
    if [ -f "$target_icon" ] && ! rm "$target_icon"; then
        log_error "Failed to remove existing icon file: $target_icon"
        exit 1
    fi

    # Create new Icon file and set attributes
    if cp "$icon_file_to_use" "$target_icon"; then
        if ! set_icon_attributes "$target_dir" "$target_icon"; then
            log_error "Failed to set icon attributes"
            exit 1
        fi
    else
        log_error "Failed to copy icon file"
        exit 1
    fi

    # Verify if the icon was set correctly
    if [ ! -f "$target_icon" ]; then
        log_error "Icon file was not created successfully"
        exit 1
    fi

    echo "Process completed: $(basename "$target_dir")"
}

# Usage check and execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <target_dir_path>" >&2
    exit 1
fi

# Convert relative path to absolute path
full_path="$(cd "$(dirname "$1")" && pwd -P)/$(basename "$1")"

mkdevdir "$full_path"
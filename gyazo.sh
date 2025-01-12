#!/bin/bash

# Check if GYAZO_ACCESS_TOKEN is set
if [ -z "${GYAZO_ACCESS_TOKEN}" ]; then
    echo "Error: GYAZO_ACCESS_TOKEN environment variable is not set" >&2
    exit 1
fi

# Check if file path argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file_path>" >&2
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check required commands
for cmd in jq curl; do
    if ! command_exists "$cmd"; then
        echo "Error: Required command '$cmd' is not installed" >&2
        exit 1
    fi
done

# Get the file path argument and check if it exists
file_path="$1"
if [ ! -f "$file_path" ] || [ ! -r "$file_path" ]; then
    echo "Error: File '$file_path' does not exist or is not readable" >&2
    exit 1
fi

# Upload to Gyazo and output permalink URL
curl -s -X POST \
     -H "Authorization: Bearer ${GYAZO_ACCESS_TOKEN}" \
     -F "imagedata=@${file_path}" \
     https://upload.gyazo.com/api/upload | jq -r '.permalink_url'

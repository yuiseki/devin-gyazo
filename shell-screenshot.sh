#!/bin/bash

# shell-screenshot.sh
# Usage: ./shell-screenshot.sh <command>
# This script captures the output of a shell command and saves it to /home/ubuntu/screenshots/

# Check if a command was provided
if [ $# -eq 0 ]; then
    echo "Error: No command provided"
    echo "Usage: $0 <command>"
    exit 1
fi

# Ensure screenshots directory exists
screenshots_dir="/home/ubuntu/screenshots"
mkdir -p "${screenshots_dir}"

# Generate timestamp for unique filename
timestamp=$(date +%Y%m%d_%H%M%S)
output_file="${screenshots_dir}/shell_${timestamp}.out"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if script command is available
if ! command_exists script; then
    echo "Error: 'script' command not found"
    exit 1
fi

# Capture the command output
echo "Capturing output of command: $*"
script -q -c "$*" "${output_file}"

# Check if capture was successful
if [ $? -eq 0 ] && [ -f "${output_file}" ]; then
    echo "Shell output captured successfully"
    
    # Convert text to image
    image_file="${screenshots_dir}/shell_${timestamp}.png"
    # Create base image
    convert -size 800x400 xc:white "${image_file}"
    
    # Add text line by line
    y_pos=20
    while IFS= read -r line; do
        # Escape special characters in the line
        escaped_line=$(echo "$line" | sed 's/"/\\"/g')
        # Add the line to the image
        convert "${image_file}" -pointsize 12 -font Courier -fill black \
            -draw "text 10,${y_pos} \"${escaped_line}\"" "${image_file}"
        y_pos=$((y_pos + 20))
    done < "${output_file}"
    
    if [ $? -eq 0 ] && [ -f "${image_file}" ]; then
        echo "Shell screenshot saved as image: ${image_file}"
        # Clean up text output file
        rm -f "${output_file}"
        # Output image file size for verification
        du -h "${image_file}"
    else
        echo "Error: Failed to convert output to image"
        exit 1
    fi
else
    echo "Error: Failed to capture shell output"
    exit 1
fi

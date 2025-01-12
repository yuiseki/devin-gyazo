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

# Set up color environment
export TERM=xterm-256color

# Capture the command output with color support
echo "Capturing output of command: $*"

# Force color output for common commands
if [[ "$1" == "ls" ]]; then
    command="$* --color=always"
elif [[ "$1" == "git" ]]; then
    command="git -c color.status=always -c color.ui=always $2"
else
    # Try to force color for other commands if they support it
    case "$1" in
        "grep") command="$* --color=always" ;;
        "diff") command="$* --color=always" ;;
        *) command="$*" ;;
    esac
fi

# Capture command output
script -q -c "$command" "${output_file}"

# Check if capture was successful and clean up output
if [ $? -eq 0 ] && [ -f "${output_file}" ]; then
    # Create a temporary file for cleanup
    temp_file="${output_file}.tmp"
    # Remove script headers, footers, and blank lines
    grep -v "^Script \(started\|done\)" "${output_file}" | \
    grep -v "^\[COMMAND_EXIT_CODE=" | \
    grep -v "^\[TERM=" | \
    sed '/^\s*$/d' > "${temp_file}"
    mv "${temp_file}" "${output_file}"
    
    echo "Shell output captured and cleaned successfully"
    
    # Note: ANSI color parsing is now handled by textimg

# Clean up script command metadata
clean_script_output() {
    local input_file="$1"
    local temp_file="${input_file}.tmp"
    
    # Remove script command metadata and empty lines
    grep -v "^Script \(started\|done\)" "${input_file}" | \
    grep -v "^\[COMMAND_EXIT_CODE=" | \
    grep -v "^\[TERM=" | \
    grep -v "^.*\[?.*@.*\].*$" | \
    sed '/^\s*$/d' > "${temp_file}"
    
    mv "${temp_file}" "${input_file}"
}

# Clean the captured output
clean_script_output "${output_file}"

# Convert text to image using textimg
image_file="${screenshots_dir}/shell_${timestamp}.png"
echo "Converting shell output to image using textimg..."
# Convert hex color #2B2B2B to RGB format (43,43,43) and use full font path
textimg -b "43,43,43,255" -f "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf" -o "${image_file}" < "${output_file}"
    
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

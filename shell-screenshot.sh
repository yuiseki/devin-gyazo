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
    
    # Function to parse ANSI color codes and text segments
parse_ansi_color_line() {
    local line="$1"
    local current_text=""
    local current_color="#D4D4D4"  # Default color
    
    # Process the line character by character
    while [ -n "$line" ]; do
        if [[ "$line" =~ ^\x1B\[([0-9;]*)m(.*)$ ]]; then
            # We found a color code
            if [ -n "$current_text" ]; then
                # Output accumulated text with its color
                printf "%s|%s\n" "$current_color" "$current_text"
                current_text=""
            fi
            
            color_code="${BASH_REMATCH[1]}"
            case "$color_code" in
                "0") current_color="#D4D4D4" ;;  # Reset
                "30") current_color="#4E4E4E" ;; # Black
                "31") current_color="#FF5555" ;; # Red
                "32") current_color="#50FA7B" ;; # Green
                "33") current_color="#F1FA8C" ;; # Yellow
                "34") current_color="#8BE9FD" ;; # Blue
                "35") current_color="#BD93F9" ;; # Magenta
                "36") current_color="#8BE9FD" ;; # Cyan
                "37") current_color="#F8F8F2" ;; # White
                *) # Handle compound codes like "01;34"
                    if [[ "$color_code" =~ 1|01|01\;3([0-7])|1\;3([0-7]) ]]; then
                        # Bold/bright version of colors
                        case "${BASH_REMATCH[1]}${BASH_REMATCH[2]}" in
                            "4") current_color="#8BE9FD" ;; # Bright blue
                            "2") current_color="#69FF94" ;; # Bright green
                            *) : ;; # Keep current color for unknown codes
                        esac
                    fi
                    ;;
            esac
            line="${BASH_REMATCH[2]}"
        else
            # No more color codes, accumulate next character
            current_text="${current_text}${line:0:1}"
            line="${line:1}"
        fi
    done
    
    # Output any remaining text
    if [ -n "$current_text" ]; then
        printf "%s|%s\n" "$current_color" "$current_text"
    fi
}

# Convert text to image
image_file="${screenshots_dir}/shell_${timestamp}.png"
# Create base image with dark theme matching terminal
convert -size 800x400 xc:'#2B2B2B' "${image_file}"

# Process each line with color support
y_pos=25
while IFS= read -r line; do
    # Start at the left margin for each line
    x_pos=15
    
    # Parse the line into colored segments
    while IFS='|' read -r color text; do
        if [ -n "$text" ]; then
            # Escape special characters in the text
            escaped_text=$(echo "$text" | sed 's/"/\\"/g')
            # Draw this segment with its color
            convert "${image_file}" -pointsize 14 -font "DejaVu-Sans-Mono" \
                -fill "$color" \
                -draw "text ${x_pos},${y_pos} \"${escaped_text}\"" \
                "${image_file}"
            # Move x position forward based on text length
            # Assuming monospace font where each character is ~8 pixels wide
            text_length=${#text}
            x_pos=$((x_pos + text_length * 8))
        fi
    done < <(parse_ansi_color_line "$line")
    
    # Move to next line
    y_pos=$((y_pos + 25))
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

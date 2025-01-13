#!/bin/bash

# gyazo-browser.sh
# Usage: ./gyazo-browser.sh <title> <referer_url>
# This script uploads browser screenshots to Gyazo with metadata
# Note: The title parameter should be the original webpage title, preserved as-is

# Check if GYAZO_ACCESS_TOKEN is set
if [ -z "${GYAZO_ACCESS_TOKEN}" ]; then
    echo "Error: GYAZO_ACCESS_TOKEN environment variable is not set" >&2
    exit 1
fi

# Function to get browser page info using JavaScript
get_browser_info() {
    # Run JavaScript to get page title and URL
    run_javascript_browser "console.log('PAGE_TITLE=' + document.title); console.log('PAGE_URL=' + window.location.href);" >/dev/null 2>&1
    
    # Get console output and parse for title and URL
    console_output=$(get_browser_console)
    
    # Extract title and URL using grep and cut
    page_title=$(echo "$console_output" | grep "PAGE_TITLE=" | cut -d'=' -f2-)
    page_url=$(echo "$console_output" | grep "PAGE_URL=" | cut -d'=' -f2-)
    
    # Verify we got both values
    if [ -z "$page_title" ] || [ -z "$page_url" ]; then
        echo "Error: Failed to get page title or URL from browser" >&2
        exit 1
    fi
    
    # Set global variables
    title="$page_title"
    referer_url="$page_url"
}

# Check parameters
if [ $# -eq 1 ] && [ "$1" = "auto" ]; then
    echo "Auto mode: Getting page info from browser..."
    get_browser_info
elif [ $# -lt 2 ]; then
    echo "Usage: $0 [auto | <webpage_title> <referer_url>]" >&2
    echo "Examples:" >&2
    echo "  $0 auto                           # Auto-detect title and URL from browser" >&2
    echo "  $0 'Example Domain' 'https://example.com'  # Manually specify title and URL" >&2
    echo "Note: webpage_title should be the original page title, preserved exactly as shown in the browser" >&2
    exit 1
else
    title="$1"
    referer_url="$2"
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

# Get parameters
title="$1"
referer_url="$2"

# Get current timestamp for unique filename
timestamp=$(date +%Y%m%d_%H%M%S)
screenshot_path="/home/ubuntu/screenshots/browser_${timestamp}.png"

# Ensure screenshots directory exists
mkdir -p /home/ubuntu/screenshots

# Find the most recent screenshot
echo "Looking for recent screenshot..."
latest_screenshot=$(ls -t /home/ubuntu/screenshots/browser_*.png 2>/dev/null | head -n1)

if [ -z "$latest_screenshot" ]; then
    echo "Error: No screenshot found in /home/ubuntu/screenshots/" >&2
    exit 1
fi

echo "Found screenshot: $latest_screenshot"
cp "$latest_screenshot" "${screenshot_path}"

# Ensure the screenshot exists and is readable
if [ ! -f "${screenshot_path}" ]; then
    echo "Error: Screenshot file not found at ${screenshot_path}" >&2
    exit 1
fi

# Upload to Gyazo with metadata and extract permalink URL
if [ -f "${screenshot_path}" ]; then
    echo "Uploading screenshot to Gyazo..."
    curl -s -X POST \
         -H "Authorization: Bearer ${GYAZO_ACCESS_TOKEN}" \
         -F "imagedata=@${screenshot_path}" \
         -F "app=Devin Browser" \
         -F "title=${title}" \
         -F "referer_url=${referer_url}" \
         https://upload.gyazo.com/api/upload | jq -r '.permalink_url'
    
    # Clean up screenshot file after successful upload
    rm -f "${screenshot_path}"
else
    echo "Error: Screenshot file not found" >&2
    exit 1
fi

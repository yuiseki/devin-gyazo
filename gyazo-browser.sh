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

# Function to get browser page info using Node.js script
get_browser_info() {
    echo "Getting page info from browser..."
    local script_dir
    script_dir="$(dirname "$0")"
    local info
    
    # Check Node.js and required packages for auto mode
    if ! command -v node >/dev/null 2>&1; then
        echo "Error: Node.js is required for auto mode but not installed" >&2
        echo "Please install Node.js using your package manager" >&2
        exit 1
    fi
    
    if ! command -v nc >/dev/null 2>&1; then
        echo "Error: netcat (nc) is required for auto mode but not installed" >&2
        echo "Please install netcat using: sudo apt-get install netcat" >&2
        exit 1
    fi
    
    if [ ! -f "${script_dir}/package.json" ]; then
        echo "Initializing Node.js project for auto mode..."
        (cd "${script_dir}" && npm init -y)
    fi
    
    if [ ! -d "${script_dir}/node_modules/playwright" ]; then
        echo "Installing Playwright for auto mode..."
        (cd "${script_dir}" && npm install playwright)
    fi
    
    # Run the Node.js script and capture its output
    browser_info=$(node "${script_dir}/get_browser_info.js")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to get page info from browser" >&2
        exit 1
    fi
    
    # Parse the output lines to get title and URL
    title=$(echo "$browser_info" | grep "TITLE:" | sed 's/TITLE: //')
    referer_url=$(echo "$browser_info" | grep "URL:" | sed 's/URL: //')
    
    if [ -z "$title" ] || [ -z "$referer_url" ]; then
        echo "Error: Failed to parse page info from browser" >&2
        exit 1
    fi
    
    echo "Detected title: $title"
    echo "Detected URL: $referer_url"
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

# Auto mode dependencies are checked within get_browser_info

# Parameters have already been set by either get_browser_info() or command line arguments

# Ensure screenshots directory exists
mkdir -p /home/ubuntu/screenshots

# Get current timestamp for unique filename
timestamp=$(date +%Y%m%d_%H%M%S)
screenshot_path="/home/ubuntu/screenshots/browser_${timestamp}.png"

# Find the most recent screenshot
echo "Looking for recent screenshot..."
latest_screenshot=$(ls -t /home/ubuntu/screenshots/browser_*.png 2>/dev/null | head -n1)
if [ -z "$latest_screenshot" ]; then
    echo "Error: No screenshot found in /home/ubuntu/screenshots/" >&2
    exit 1
fi

echo "Found screenshot: $latest_screenshot"
cp "$latest_screenshot" "${screenshot_path}"

if [ ! -f "${screenshot_path}" ]; then
    echo "Error: Screenshot file not found at ${screenshot_path}" >&2
    exit 1
fi

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

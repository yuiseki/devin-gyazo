# devin-gyazo

A collection of automation scripts for capturing and uploading screenshots to Gyazo.

## Features

- Automated browser screenshot capture with metadata support (preserves webpage titles)
- Shell output capture with ANSI color support
- Direct upload to Gyazo using API with app identification
- JSON response parsing for permalink URL extraction
- Automatic cleanup of temporary files

## Requirements

- `curl` for API requests
- `jq` for JSON parsing
- `textimg` for terminal text rendering and ANSI color support
- Gyazo account and access token (see [Setup Guide](SETUP.md))
- (Optional) Noto Sans CJK font for better CJK character rendering

## Setup

1. Clone the repository:
   ```bash
   cd ~/repos/
   git clone https://github.com/yuiseki/devin-gyazo.git
   ```

2. Install Node.js dependencies (required for auto mode):
   ```bash
   cd ~/repos/devin-gyazo
   npm ci
   ```

3. Ensure you have the required tools installed:
   ```bash
   sudo apt-get update
   sudo apt-get install -y curl jq
   
   # Install textimg for terminal text rendering
   wget https://github.com/jiro4989/textimg/releases/download/v3.1.9/textimg_3.1.9_linux_amd64.deb
   sudo dpkg -i textimg_3.1.9_linux_amd64.deb
   
   # Optional: Install Noto Sans CJK font for better CJK support
   wget https://github.com/notofonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK-Regular.ttc
   sudo mkdir -p /usr/share/fonts/truetype/noto
   sudo mv NotoSansCJK-Regular.ttc /usr/share/fonts/truetype/noto/
   sudo fc-cache -f -v
   ```

2. Set up your Gyazo access token:
   ```bash
   export GYAZO_ACCESS_TOKEN="your-access-token-here"
   ```

## Usage

### Browser Screenshots

Use gyazo-browser.sh to upload browser screenshots with metadata. You can use either auto mode or manual mode:

### Auto Mode
```bash
~/repos/devin-gyazo/gyazo-browser.sh auto
```
This will automatically capture a screenshot of the current browser tab and upload it to Gyazo with the page's title and URL.

### Manual Mode
```bash
~/repos/devin-gyazo/gyazo-browser.sh "Page Title" "https://example.com"
```
Before running in manual mode:
1. Take a screenshot of your browser and save it to `/home/ubuntu/screenshots/`
2. Run the script with the exact page title and URL from your browser

The script will:
1. Find the most recent browser screenshot (browser_*.png)
2. Upload it to Gyazo with metadata:
   - App name: "Devin Browser"
   - Title: original webpage title (preserved as-is)
   - Referer URL: specified page URL
3. Output the Gyazo permalink URL
4. Clean up temporary files

### Shell Output

Use gyazo-shell.sh to capture and upload shell output:

```bash
~/repos/devin-gyazo/gyazo-shell.sh "ls -la"
```

The script will:
1. Capture the command output with ANSI colors
2. Convert the output to an image
3. Upload to Gyazo with app name "Devin Shell"
4. Output the Gyazo permalink URL
5. Clean up temporary files

## Error Handling

The script includes various error checks:
- Verifies GYAZO_ACCESS_TOKEN is set
- Checks for required commands (curl, jq)
- Validates screenshot file existence
- Handles upload failures gracefully

## License

MIT License

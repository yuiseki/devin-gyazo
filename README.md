# devin-gyazo

A Node.js CLI tool for Devin to capture and upload screenshots to Gyazo.

## Features

- Automated browser screenshot capture with metadata support
- Preserves webpage titles and URLs automatically
- Direct upload to Gyazo using API
- Clean and simple CLI interface
- Automatic cleanup of temporary files

## Requirements

- Gyazo account and access token (see [Setup Guide](SETUP.md))
- Node.js and npm
- textimg command for shell output capture (required for `shell` subcommand)

## Installation

### Install devin-gyazo

Install globally using npm:
```bash
npm install -g @yuiseki/devin-gyazo
```

### Install textimg (required for shell command)

The `shell` subcommand requires textimg for capturing terminal output:

```bash
# For Debian/Ubuntu:
wget https://github.com/jiro4989/textimg/releases/download/v3.1.10/textimg_3.1.10_amd64.deb
sudo dpkg -i textimg_3.1.10_amd64.deb

# For RHEL/CentOS:
sudo yum install https://github.com/jiro4989/textimg/releases/download/v3.1.10/textimg-3.1.10-1.el7.x86_64.rpm

# If you have Go installed:
go get -u github.com/jiro4989/textimg/v3

If you run into trouble, see https://github.com/jiro4989/textimg

# Optional: For better Japanese (CJK) text rendering:
# Download and install Noto Sans CJK font
wget -O NotoSansCJK-Regular.ttc https://github.com/notofonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK-Regular.ttc
sudo mkdir -p /usr/share/fonts/truetype/noto
sudo mv NotoSansCJK-Regular.ttc /usr/share/fonts/truetype/noto/
sudo fc-cache -f -v

Note: Japanese text rendering requires the Noto Sans CJK font. Install it using the commands above if you need to capture Japanese terminal output.
```

Set up your Gyazo access token:
```bash
export GYAZO_ACCESS_TOKEN="your-access-token-here"
```

## Usage

### Browser Screenshots
```bash
# Auto-detect title and URL from current browser tab
devin-gyazo browser

# Same as above, explicitly using auto mode
devin-gyazo browser auto

# Manually specify title and URL
devin-gyazo browser "Page Title" "https://example.com"
```

The browser command will:
1. Capture the current browser tab screenshot
2. Upload it to Gyazo with metadata:
   - Title: webpage title
   - URL: webpage URL
3. Output the Gyazo permalink URL
4. Clean up temporary files

### Shell Output Screenshots
```bash
# Capture and upload command output
devin-gyazo shell ls -la

# Works with any shell command
devin-gyazo shell "git status"
```

To verify textimg installation and shell command functionality:
```bash
# This should succeed and return a Gyazo URL if textimg is installed
devin-gyazo shell ls -alh

# If textimg is not installed, you'll see an error message directing you to the installation instructions
```

The shell command will:
1. Capture the command output with ANSI colors
2. Convert the output to an image
3. Upload to Gyazo and return the permalink URL
4. Clean up temporary files

## License

MIT License

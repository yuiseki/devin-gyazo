# devin-gyazo

A Node.js CLI tool for capturing and uploading browser screenshots to Gyazo.

## Features

- Automated browser screenshot capture with metadata support
- Preserves webpage titles and URLs automatically
- Direct upload to Gyazo using API
- Clean and simple CLI interface
- Automatic cleanup of temporary files

## Requirements

- Gyazo account and access token (see [Setup Guide](SETUP.md))
- Node.js and npm

## Installation

Install globally using npm:
```bash
npm install -g @yuiseki/devin-gyazo
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

The shell command will:
1. Capture the command output with ANSI colors
2. Convert the output to an image
3. Upload to Gyazo and return the permalink URL
4. Clean up temporary files

## License

MIT License

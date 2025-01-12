# devin-gyazo

A collection of automation scripts for capturing and uploading screenshots to Gyazo.

## Features

- Automated browser screenshot capture
- Direct upload to Gyazo using API
- JSON response parsing for permalink URL extraction
- Automatic cleanup of temporary files

## Requirements

- `curl` for API requests
- `jq` for JSON parsing
- Gyazo account and access token

## Setup

1. Ensure you have the required tools installed:
   ```bash
   sudo apt-get update
   sudo apt-get install -y curl jq
   ```

2. Set up your Gyazo access token:
   ```bash
   export GYAZO_ACCESS_TOKEN="your-access-token-here"
   ```

## Usage

The script will automatically find the most recent screenshot in the `/home/ubuntu/screenshots/` directory and upload it to Gyazo:

```bash
./gyazo-screenshot.sh
```

The script will:
1. Look for the most recent screenshot
2. Upload it to Gyazo
3. Output the Gyazo permalink URL
4. Clean up temporary files

## Error Handling

The script includes various error checks:
- Verifies GYAZO_ACCESS_TOKEN is set
- Checks for required commands (curl, jq)
- Validates screenshot file existence
- Handles upload failures gracefully

## License

MIT License

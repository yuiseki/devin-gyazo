# Development Testing Guide

This document outlines the testing procedures for developing and testing the devin-gyazo CLI commands. For end-user installation and usage, please refer to the README.md file.

## Prerequisites

1. Set up local development environment:
   ```bash
   # Clone the repository
   git clone https://github.com/yuiseki/devin-gyazo.git
   cd devin-gyazo

   # Install dependencies
   npm install

   # Create a global symlink
   npm link

   # Verify the command is available
   devin-gyazo --help
   ```

2. Set up your Gyazo access token:
   ```bash
   export GYAZO_ACCESS_TOKEN="your-access-token"
   ```

## Browser Screenshot Testing

### Testing `browser auto` Command

1. Open a specific webpage in your browser (e.g., https://www.cas.go.jp/)
2. Run the browser auto command:
   ```bash
   devin-gyazo browser auto
   ```
3. Verify the results:
   - Check that the command executes successfully
   - Open the returned Gyazo URL in your browser
   - Verify that the screenshot shows the correct webpage content
   - Confirm that the title and URL metadata are correctly captured

### Example Test Case: Cabinet Secretariat Website

1. Open the Cabinet Secretariat website:
   ```bash
   # Navigate to the website in your browser
   https://www.cas.go.jp/
   ```

2. Execute the browser auto command:
   ```bash
   devin-gyazo browser auto
   ```

3. Expected Results:
   - Command returns a Gyazo URL
   - Screenshot shows the Cabinet Secretariat website
   - Title matches the webpage title
   - URL metadata shows https://www.cas.go.jp/

### Manual Mode Testing

1. Open any webpage in your browser
2. Run the browser command with manual parameters:
   ```bash
   devin-gyazo browser "Page Title" "https://example.com"
   ```
3. Verify the results following the same steps as auto mode

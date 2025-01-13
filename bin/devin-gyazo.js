#!/usr/bin/env node

const { spawnSync } = require('child_process');
const path = require('path');

// Get the directory where the CLI script is located
const scriptDir = __dirname;

// Get command line arguments (skip 'node' and script name)
const args = process.argv.slice(2);

if (args.length === 0) {
  console.log('devin-gyazo CLI - A collection of automation scripts for capturing and uploading screenshots to Gyazo.');
  console.log('\nUsage:');
  console.log('  devin-gyazo browser auto                        # Auto-detect title and URL from browser');
  console.log('  devin-gyazo browser <webpage_title> <url>       # Manually specify title and URL');
  process.exit(1);
}

const command = args[0];

if (command === 'browser') {
  // Path to the browser screenshot script
  const browserScript = path.resolve(scriptDir, '..', 'gyazo-browser.sh');
  
  // Remove the 'browser' command from args
  const scriptArgs = args.slice(1);
  
  if (scriptArgs.length === 0) {
    console.error('Error: Missing arguments for browser command');
    console.log('\nUsage:');
    console.log('  devin-gyazo browser auto                        # Auto-detect title and URL from browser');
    console.log('  devin-gyazo browser <webpage_title> <url>       # Manually specify title and URL');
    process.exit(1);
  }

  // Execute the browser screenshot script with the remaining arguments
  const result = spawnSync(browserScript, scriptArgs, {
    stdio: 'inherit',
    shell: true
  });

  process.exit(result.status);
} else {
  console.error(`Error: Unknown command '${command}'`);
  console.log('\nUsage:');
  console.log('  devin-gyazo browser auto                        # Auto-detect title and URL from browser');
  console.log('  devin-gyazo browser <webpage_title> <url>       # Manually specify title and URL');
  process.exit(1);
}

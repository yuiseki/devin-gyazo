#!/usr/bin/env node

const { handleBrowserCommand } = require('../src/browser');

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
  // Remove the 'browser' command from args
  const commandArgs = args.slice(1);
  
  if (commandArgs.length === 0) {
    console.error('Error: Missing arguments for browser command');
    console.log('\nUsage:');
    console.log('  devin-gyazo browser auto                        # Auto-detect title and URL from browser');
    console.log('  devin-gyazo browser <webpage_title> <url>       # Manually specify title and URL');
    process.exit(1);
  }

  handleBrowserCommand(commandArgs).catch(error => {
    console.error('Error:', error.message);
    process.exit(1);
  });
} else {
  console.error(`Error: Unknown command '${command}'`);
  console.log('\nUsage:');
  console.log('  devin-gyazo browser auto                        # Auto-detect title and URL from browser');
  console.log('  devin-gyazo browser <webpage_title> <url>       # Manually specify title and URL');
  process.exit(1);
}

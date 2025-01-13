const { execSync, spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const FormData = require('form-data');
const https = require('https');

// Ensure screenshots directory exists
const screenshotsDir = '/home/ubuntu/screenshots';
if (!fs.existsSync(screenshotsDir)) {
  fs.mkdirSync(screenshotsDir, { recursive: true });
}

// Check if textimg command exists
function checkTextimgCommand() {
  try {
    execSync('which textimg', { stdio: 'ignore' });
    return true;
  } catch (error) {
    throw new Error('textimg command not found. Please install textimg first. See README for installation instructions.');
  }
}

// Helper for uploading to Gyazo
async function uploadToGyazo(filePath) {
  if (!process.env.GYAZO_ACCESS_TOKEN) {
    throw new Error('GYAZO_ACCESS_TOKEN environment variable is not set');
  }

  const form = new FormData();
  form.append('imagedata', fs.createReadStream(filePath));
  form.append('app', 'Devin Shell');

  return new Promise((resolve, reject) => {
    const req = https.request({
      hostname: 'upload.gyazo.com',
      path: '/api/upload',
      method: 'POST',
      headers: {
        Authorization: `Bearer ${process.env.GYAZO_ACCESS_TOKEN}`,
        ...form.getHeaders()
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const response = JSON.parse(data);
          resolve(response.permalink_url);
        } catch (error) {
          reject(new Error('Failed to parse Gyazo response'));
        }
      });
    });

    req.on('error', reject);
    form.pipe(req);
  });
}

// Main handler for "shell" command
async function handleShellCommand(args) {
  try {
    // Check if textimg is installed
    checkTextimgCommand();

    // Check if command was provided
    if (args.length === 0) {
      console.error('Error: No shell command provided');
      console.error('Usage: devin-gyazo shell <command> [args...]');
      process.exit(1);
    }

    // Prepare command with color support for known commands
    let commandToRun = args.join(' ');
    const firstArg = args[0].toLowerCase();
    if (['ls', 'git', 'grep', 'diff'].includes(firstArg)) {
      commandToRun += ' --color=always';
    }

    // Generate unique filenames with timestamp
    const timestamp = Date.now();
    const textOutputPath = path.join(screenshotsDir, `shell_${timestamp}.out`);
    const imageOutputPath = path.join(screenshotsDir, `shell_${timestamp}.png`);

    // Capture command output with color support using script
    const scriptCommand = `script -q -c "${commandToRun}" ${textOutputPath}`;
    const scriptResult = spawnSync(scriptCommand, {
      shell: true,
      env: {
        ...process.env,
        TERM: 'xterm-256color'
      }
    });

    if (scriptResult.status !== 0) {
      console.error('Error capturing shell output');
      process.exit(1);
    }

    // Clean up captured text output (remove script headers/footers)
    spawnSync(
      `grep -v "^Script " ${textOutputPath} | grep -v "^\\[.*@.*\\].*$" | sed '/^\\s*$/d' > ${textOutputPath}.tmp`,
      { shell: true }
    );
    spawnSync(`mv ${textOutputPath}.tmp ${textOutputPath}`, { shell: true });

    // Convert text to image using textimg
    const textimgCmd = `textimg -b "43,43,43,255" -f "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf" -o "${imageOutputPath}" < "${textOutputPath}"`;
    const textimgResult = spawnSync(textimgCmd, { shell: true });
    
    if (textimgResult.status !== 0) {
      console.error('Error converting output to image with textimg');
      process.exit(1);
    }

    // Upload screenshot to Gyazo
    const gyazoUrl = await uploadToGyazo(imageOutputPath);
    console.log(gyazoUrl);

    // Clean up temporary files
    fs.unlinkSync(textOutputPath);
    fs.unlinkSync(imageOutputPath);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

module.exports = {
  handleShellCommand
};

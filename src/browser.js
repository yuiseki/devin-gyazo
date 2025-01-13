const { chromium } = require('playwright');
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const https = require('https');
const FormData = require('form-data');

// Ensure screenshots directory exists
const screenshotsDir = '/home/ubuntu/screenshots';
if (!fs.existsSync(screenshotsDir)) {
  fs.mkdirSync(screenshotsDir, { recursive: true });
}

function getDebugPort() {
  try {
    const processes = execSync(
      "ps aux | grep -v grep | grep chrome | grep remote-debugging-port"
    ).toString();
    const lines = processes.split("\n").filter((line) => line.trim());

    for (const line of lines) {
      const portMatch = line.match(/--remote-debugging-port=(\d+)/);
      if (portMatch && portMatch[1]) {
        const port = portMatch[1];
        try {
          execSync(`nc -z localhost ${port}`);
          return port;
        } catch (e) {
          continue;
        }
      }
    }
    throw new Error("No active Chrome debugging port found");
  } catch (error) {
    if (error.message.includes("No active Chrome")) {
      console.error(
        "Error: No Chrome instance found with remote debugging enabled"
      );
    } else {
      console.error("Error finding Chrome debug port:", error.message);
    }
    process.exit(1);
  }
}

async function getBrowserInfo() {
  const port = getDebugPort();
  console.error(`Connecting to Chrome on port ${port}...`);

  const browser = await chromium.connectOverCDP(`http://localhost:${port}`);
  const contexts = browser.contexts();

  if (contexts.length === 0) {
    throw new Error("No browser contexts found");
  }

  const pages = contexts[0].pages();
  if (pages.length === 0) {
    throw new Error("No pages found in browser context");
  }

  const page = pages[0];
  await page.waitForLoadState("networkidle");

  const screenshotsDir = '/home/ubuntu/screenshots';
  if (!fs.existsSync(screenshotsDir)) {
    fs.mkdirSync(screenshotsDir, { recursive: true });
  }

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const screenshotPath = path.join(screenshotsDir, `browser_${timestamp}.png`);
  await page.screenshot({ path: screenshotPath });

  const info = {
    title: await page.title(),
    url: page.url(),
    screenshotPath
  };

  await browser.close();
  return info;
}

async function uploadToGyazo(filePath, title, refererUrl) {
  if (!process.env.GYAZO_ACCESS_TOKEN) {
    throw new Error('GYAZO_ACCESS_TOKEN environment variable is not set');
  }

  const form = new FormData();
  form.append('imagedata', fs.createReadStream(filePath));
  form.append('app', 'Devin Browser');
  if (title) form.append('title', title);
  if (refererUrl) form.append('referer_url', refererUrl);

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

async function handleBrowserCommand(args) {
  try {
    let title, url, screenshotPath;

    if (args[0] === 'auto') {
      const info = await getBrowserInfo();
      title = info.title;
      url = info.url;
      screenshotPath = info.screenshotPath;
    } else if (args.length >= 2) {
      title = args[0];
      url = args[1];
      // Take screenshot using current browser info
      const info = await getBrowserInfo();
      screenshotPath = info.screenshotPath;
    } else {
      console.error('Error: Invalid arguments');
      console.error('Usage:');
      console.error('  devin-gyazo browser auto');
      console.error('  devin-gyazo browser <webpage_title> <url>');
      process.exit(1);
    }

    const gyazoUrl = await uploadToGyazo(screenshotPath, title, url);
    console.log(gyazoUrl);

    // Clean up screenshot file
    fs.unlinkSync(screenshotPath);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

module.exports = { handleBrowserCommand };

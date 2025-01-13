const { chromium } = require("playwright");
const { execSync } = require("child_process");

function getDebugPort() {
  try {
    // Get Chrome process info and extract debugging port
    const processes = execSync(
      "ps aux | grep -v grep | grep chrome | grep remote-debugging-port"
    ).toString();
    const lines = processes.split("\n").filter((line) => line.trim());

    for (const line of lines) {
      const portMatch = line.match(/--remote-debugging-port=(\d+)/);
      if (portMatch && portMatch[1]) {
        const port = portMatch[1];
        // Verify port is actually in use
        try {
          execSync(`nc -z localhost ${port}`);
          return port;
        } catch (e) {
          // Port not responding, try next one
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

(async () => {
  try {
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

    // Ensure screenshots directory exists
    const fs = require('fs');
    const screenshotsDir = '/home/ubuntu/screenshots';
    if (!fs.existsSync(screenshotsDir)) {
      fs.mkdirSync(screenshotsDir, { recursive: true });
    }

    // Take screenshot with timestamp using playwright prefix
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const screenshotPath = `${screenshotsDir}/playwright_${timestamp}.png`;
    await page.screenshot({ path: screenshotPath });

    const info = {
      title: await page.title(),
      url: page.url(),
    };

    // Output page info
    console.log(`TITLE: ${info.title}`);
    console.log(`URL: ${info.url}`);

    await browser.close();
  } catch (error) {
    console.error("Error:", error.message);
    process.exit(1);
  }
})();

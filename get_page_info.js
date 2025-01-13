const { chromium } = require('playwright');

(async () => {
  try {
    // TODO: Need to determine correct port
    const browser = await chromium.connectOverCDP('http://localhost:49539');
    
    // Get default browser context
    const [context] = browser.contexts();
    
    // Get active page
    const [page] = context.pages();
    
    // Wait for page to be stable
    await page.waitForLoadState('networkidle');
    
    // Get page title and URL
    const title = await page.title();
    const url = page.url();
    
    // Display results
    console.log(`タイトル: ${title}`);
    console.log(`URL: ${url}`);
    
    // Close browser connection
    await browser.close();
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
})();

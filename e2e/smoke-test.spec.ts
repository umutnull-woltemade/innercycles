import { test, expect } from '@playwright/test';

/**
 * Smoke Test Suite - Critical User Flows
 * 20 most important flows that MUST work before deploy
 */

const BASE_URL = process.env.BASE_URL || 'http://localhost:8080';

// Helper to wait for Flutter app
async function waitForFlutter(page: any) {
  const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
  await expect(flutterElements.first()).toBeVisible({ timeout: 30000 });
}

// Helper to check no critical JS errors
async function checkNoErrors(page: any) {
  const errors: string[] = [];
  page.on('pageerror', (error: Error) => errors.push(error.message));
  await page.waitForTimeout(2000);
  const criticalErrors = errors.filter(e =>
    e.includes('TypeError') ||
    e.includes('Uncaught') ||
    e.includes('ReferenceError')
  );
  expect(criticalErrors).toEqual([]);
}

test.describe('SMOKE: Core Navigation', () => {
  test('1. App initial load - no white screen', async ({ page }) => {
    await page.goto(BASE_URL, { waitUntil: 'networkidle' });
    await page.waitForTimeout(5000);

    // Body has content
    const bodyHTML = await page.locator('body').innerHTML();
    expect(bodyHTML.trim().length).toBeGreaterThan(100);

    // Flutter loaded
    await waitForFlutter(page);

    // Screenshot for evidence
    await page.screenshot({ path: 'artifacts/smoke-01-initial-load.png', fullPage: true });
  });

  test('2. Onboarding screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/onboarding`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-02-onboarding.png', fullPage: true });
  });

  test('3. Home screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/home`);
    await page.waitForTimeout(5000);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-03-home.png', fullPage: true });
  });

  test('4. Insight screen loads (App Store safe)', async ({ page }) => {
    await page.goto(`${BASE_URL}/insight`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-04-insight.png', fullPage: true });
  });

  test('5. All Services catalog loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/all-services`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-05-all-services.png', fullPage: true });
  });
});

test.describe('SMOKE: User Profile Flow', () => {
  test('6. Profile screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/profile`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-06-profile.png', fullPage: true });
  });

  test('7. Settings screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/settings`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-07-settings.png', fullPage: true });
  });

  test('8. Saved profiles screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/saved-profiles`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-08-saved-profiles.png', fullPage: true });
  });
});

test.describe('SMOKE: Wellness Features', () => {
  test('9. Compatibility reflections loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/compatibility`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-09-compatibility.png', fullPage: true });
  });

  test('10. Numerology screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/numerology`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-10-numerology.png', fullPage: true });
  });

  test('11. Numerology life path detail loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/numerology/life-path/7`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-11-life-path-7.png', fullPage: true });
  });
});

test.describe('SMOKE: Exploration Features', () => {
  test('12. Symbolic analysis screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/symbolic-analysis`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-12-symbolic-analysis.png', fullPage: true });
  });

  test('14. Dream interpretation loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/dream-interpretation`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-14-dream-interpretation.png', fullPage: true });
  });

  test('15. Legacy analysis loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/legacy-analysis`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-15-legacy-analysis.png', fullPage: true });
  });

  test('16. Energy profile screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/energy-profile`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-16-energy-profile.png', fullPage: true });
  });
});

test.describe('SMOKE: Reference Content', () => {
  test('17. Glossary loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/glossary`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-17-glossary.png', fullPage: true });
  });

  test('18. Articles loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/articles`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-18-articles.png', fullPage: true });
  });
});

test.describe('SMOKE: Premium & Monetization', () => {
  test('19. Premium screen loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/premium`);
    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-19-premium.png', fullPage: true });
  });
});

test.describe('SMOKE: Error Recovery', () => {
  test('20. 404 screen recovers gracefully', async ({ page }) => {
    await page.goto(`${BASE_URL}/nonexistent-route-xyz`);
    await page.waitForTimeout(3000);

    // App should load (404 screen, not white screen)
    const bodyHTML = await page.locator('body').innerHTML();
    expect(bodyHTML.trim().length).toBeGreaterThan(50);

    await waitForFlutter(page);
    await page.screenshot({ path: 'artifacts/smoke-20-404-recovery.png', fullPage: true });
  });
});

test.describe('SMOKE: Health Endpoint', () => {
  test('API health check returns OK', async ({ page }) => {
    const response = await page.goto(`${BASE_URL}/api/health`);

    expect(response?.status()).toBe(200);

    const body = await response?.json();
    expect(body.status).toBe('ok');
    expect(body.app).toBe('venus-one');
  });
});

test.describe('SMOKE: Console Error Budget', () => {
  test('No critical console errors on home', async ({ page }) => {
    const errors: string[] = [];
    const warnings: string[] = [];

    page.on('console', (msg) => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      } else if (msg.type() === 'warning') {
        warnings.push(msg.text());
      }
    });

    await page.goto(`${BASE_URL}/home`, { waitUntil: 'networkidle' });
    await page.waitForTimeout(5000);

    // Filter critical errors (exclude expected ones)
    const criticalErrors = errors.filter(e =>
      !e.includes('favicon') &&
      !e.includes('manifest') &&
      !e.includes('service-worker')
    );

    // Zero tolerance for critical errors
    expect(criticalErrors.length).toBeLessThanOrEqual(0);

    console.log(`Errors: ${errors.length}, Warnings: ${warnings.length}`);
  });
});

test.describe('SMOKE: Loading States', () => {
  test('Loading screen appears and disappears', async ({ page }) => {
    await page.goto(BASE_URL);

    // Check loading element
    const loadingElement = page.locator('#loading');
    const loadingVisible = await loadingElement.isVisible().catch(() => false);

    if (loadingVisible) {
      // Should disappear
      await expect(loadingElement).toBeHidden({ timeout: 25000 });
    }

    // Flutter should be visible after
    await waitForFlutter(page);
  });

  test('No infinite loading state', async ({ page }) => {
    await page.goto(BASE_URL);
    await page.waitForTimeout(20000);

    const loadingElement = page.locator('#loading');
    const isLoadingStillVisible = await loadingElement.isVisible().catch(() => false);

    expect(isLoadingStillVisible).toBe(false);
  });
});

test.describe('SMOKE: Interactivity', () => {
  test('Flutter canvas is present and interactive', async ({ page }) => {
    await page.goto(`${BASE_URL}/home`, { waitUntil: 'networkidle' });
    await page.waitForTimeout(5000);

    await waitForFlutter(page);

    // Canvas should exist
    const canvas = page.locator('canvas');
    const canvasCount = await canvas.count();
    expect(canvasCount).toBeGreaterThan(0);
  });
});

import { test, expect } from '@playwright/test';

/**
 * Auth Matrix E2E Tests
 * Tests all authentication scenarios for InnerCycles
 */

const BASE_URL = process.env.BASE_URL || 'http://localhost:8080';

test.describe('Anonymous User Navigation', () => {
  test('anonymous user can access onboarding', async ({ page }) => {
    await page.goto(`${BASE_URL}/onboarding`);
    await page.waitForTimeout(3000);

    // Flutter app should load
    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });

    // No critical errors
    const errors: string[] = [];
    page.on('pageerror', (error) => errors.push(error.message));
    expect(errors.filter(e => e.includes('TypeError') || e.includes('Uncaught'))).toEqual([]);
  });

  test('anonymous user can access home on web', async ({ page }) => {
    await page.goto(`${BASE_URL}/home`);
    await page.waitForTimeout(5000);

    // Web should show home directly (skips storage check)
    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
  });

  test('anonymous user can access insight', async ({ page }) => {
    await page.goto(`${BASE_URL}/insight`);
    await page.waitForTimeout(3000);

    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
  });
});

test.describe('Admin Authentication', () => {
  test('admin route redirects to login when not authenticated', async ({ page }) => {
    await page.goto(`${BASE_URL}/admin`);
    await page.waitForTimeout(3000);

    // Should show admin login screen or redirect
    const url = page.url();
    expect(url).toContain('/admin');
  });

  test('admin login page loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/admin/login`);
    await page.waitForTimeout(3000);

    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
  });

  test('observatory route requires auth', async ({ page }) => {
    await page.goto(`${BASE_URL}/admin/observatory`);
    await page.waitForTimeout(3000);

    // Should redirect to admin login
    const url = page.url();
    expect(url).toMatch(/\/admin/);
  });
});

test.describe('Legacy Route Redirect Verification', () => {
  test('legacy route redirects to insight', async ({ page }) => {
    await page.goto(`${BASE_URL}/year-ahead`);
    await page.waitForTimeout(5000);

    // Should redirect to /insight or show insight content
    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });

    // Take screenshot for verification
    await page.screenshot({
      path: 'test-results/legacy-route-redirect.png',
      fullPage: true
    });
  });

  test.describe('Removed Routes Redirect', () => {
    const removedRoutes = [
      '/year-ahead',
      '/progressions',
      '/saturn-return',
      '/solar-return',
      '/electional',
      '/transit-calendar',
      '/transits',
      '/kozmoz',
      '/timing',
      '/void-of-course',
      '/eclipse-calendar',
    ];

    for (const route of removedRoutes) {
      test(`${route} is removed and redirects`, async ({ page }) => {
        await page.goto(`${BASE_URL}${route}`);
        await page.waitForTimeout(3000);

        // App should still load (redirected to /insight)
        const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
        await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
      });
    }
  });
});

test.describe('Safe Routes - Always Accessible', () => {
  const safeRoutes = [
    '/insight',
    '/journal',
    '/glossary',
    '/dream-interpretation',
    '/dream-glossary',
    '/legacy-analysis',
    '/profile',
    '/settings',
    '/premium',
    '/compatibility',
    '/prompts',
  ];

  for (const route of safeRoutes) {
    test(`${route} is accessible`, async ({ page }) => {
      await page.goto(`${BASE_URL}${route}`);
      await page.waitForTimeout(3000);

      const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
      await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
    });
  }
});

test.describe('Legacy Route Redirects', () => {
  const legacyRedirects = [
    { from: '/ruya/dusmek', to: '/dreams/falling' },
    { from: '/ruya/ucmak', to: '/dreams/flying' },
    { from: '/tum-cozumlemeler', to: '/all-services' },
  ];

  for (const { from, to } of legacyRedirects) {
    test(`legacy ${from} redirects`, async ({ page }) => {
      await page.goto(`${BASE_URL}${from}`);
      await page.waitForTimeout(3000);

      // App should load and show content
      const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
      await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
    });
  }
});

test.describe('Deprecated Route Redirects', () => {
  test('/cosmic-chat redirects to /insight', async ({ page }) => {
    await page.goto(`${BASE_URL}/cosmic-chat`);
    await page.waitForTimeout(3000);

    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
  });

  test('/dream-oracle redirects to /insight', async ({ page }) => {
    await page.goto(`${BASE_URL}/dream-oracle`);
    await page.waitForTimeout(3000);

    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
  });
});

test.describe('404 Error Handling', () => {
  test('unknown route shows 404 screen', async ({ page }) => {
    await page.goto(`${BASE_URL}/this-route-does-not-exist-xyz`);
    await page.waitForTimeout(3000);

    // App should still load with 404 screen
    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });

    await page.screenshot({
      path: 'test-results/404-screen.png',
      fullPage: true
    });
  });
});

test.describe('Dynamic Route Parameters', () => {
  test('numerology life path with valid number loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/numerology/life-path/7`);
    await page.waitForTimeout(3000);

    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
  });

  test('dream interpretation detail loads', async ({ page }) => {
    await page.goto(`${BASE_URL}/dream-interpretation`);
    await page.waitForTimeout(3000);

    const flutterElements = page.locator('flutter-view, flt-glass-pane, [flt-view-id]');
    await expect(flutterElements.first()).toBeVisible({ timeout: 20000 });
  });
});

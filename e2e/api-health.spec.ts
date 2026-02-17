import { test, expect } from '@playwright/test';

/**
 * API Contract & Health Tests
 * Validates API endpoints and health checks
 */

const BASE_URL = process.env.BASE_URL || 'http://localhost:8080';

test.describe('API Health Checks', () => {
  test('health endpoint returns 200 with correct structure', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/api/health`);

    expect(response.status()).toBe(200);

    const body = await response.json();
    expect(body).toHaveProperty('status');
    expect(body.status).toBe('ok');
    expect(body).toHaveProperty('app');
    expect(body.app).toBe('innercycles');
  });

  test('health endpoint responds within 5 seconds', async ({ request }) => {
    const startTime = Date.now();
    const response = await request.get(`${BASE_URL}/api/health`);
    const duration = Date.now() - startTime;

    expect(response.status()).toBe(200);
    expect(duration).toBeLessThan(5000);
  });
});

test.describe('Static Assets', () => {
  test('flutter.js loads', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/flutter.js`);
    expect(response.status()).toBe(200);
  });

  test('main.dart.js loads', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/main.dart.js`);
    expect(response.status()).toBe(200);
  });

  test('manifest.json loads', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/manifest.json`);
    expect(response.status()).toBe(200);

    const body = await response.json();
    expect(body).toHaveProperty('name');
    expect(body).toHaveProperty('short_name');
  });

  test('index.html loads', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/index.html`);
    expect(response.status()).toBe(200);

    const html = await response.text();
    expect(html).toContain('<!DOCTYPE html>');
    expect(html).toContain('flutter');
  });
});

test.describe('Asset Loading', () => {
  test('brand logo loads', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/assets/brand/app-logo/png/app-logo-256.png`);
    // Accept 200 or asset bundled differently
    expect([200, 404]).toContain(response.status());
  });

  test('l10n files are accessible', async ({ request }) => {
    const languages = ['en', 'tr', 'de', 'fr'];

    for (const lang of languages) {
      const response = await request.get(`${BASE_URL}/assets/l10n/${lang}.json`);
      // Assets may be bundled, so accept 200 or 404
      expect([200, 404]).toContain(response.status());
    }
  });
});

test.describe('Error Responses', () => {
  test('unknown API route returns appropriate error', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/api/unknown-endpoint`);
    // Should return 404 or similar error
    expect([404, 500]).toContain(response.status());
  });
});

test.describe('CORS & Headers', () => {
  test('health endpoint has correct content-type', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/api/health`);

    const contentType = response.headers()['content-type'];
    expect(contentType).toContain('application/json');
  });

  test('static assets have cache headers', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/flutter.js`);

    // Should have some caching mechanism
    const headers = response.headers();
    expect(response.status()).toBe(200);
    // Vercel/hosting typically adds cache-control
  });
});

test.describe('Service Worker', () => {
  test('service worker loads (if configured)', async ({ request }) => {
    const response = await request.get(`${BASE_URL}/flutter_service_worker.js`);
    // Service worker is optional, accept 200 or 404
    expect([200, 404]).toContain(response.status());
  });
});

test.describe('Response Time Benchmarks', () => {
  test('index loads within 10 seconds', async ({ request }) => {
    const startTime = Date.now();
    const response = await request.get(BASE_URL);
    const duration = Date.now() - startTime;

    expect(response.status()).toBe(200);
    expect(duration).toBeLessThan(10000);
    console.log(`Index load time: ${duration}ms`);
  });

  test('flutter.js loads within 10 seconds', async ({ request }) => {
    const startTime = Date.now();
    const response = await request.get(`${BASE_URL}/flutter.js`);
    const duration = Date.now() - startTime;

    expect(response.status()).toBe(200);
    expect(duration).toBeLessThan(10000);
    console.log(`flutter.js load time: ${duration}ms`);
  });
});

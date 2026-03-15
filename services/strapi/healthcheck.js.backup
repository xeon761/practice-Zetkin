#!/usr/bin/env node
/**
 * Healthcheck script for Strapi
 * Returns exit code 0 if server is healthy, 1 otherwise
 */

const http = require('http');

const CONFIG = {
  host: 'localhost',
  port: process.env.PORT || 1337,
  path: '/',  // Проверяем корень — он всегда отвечает
  timeout: 5000
};

const request = http.request(
  {
    hostname: CONFIG.host,
    port: CONFIG.port,
    path: CONFIG.path,
    method: 'GET',
    timeout: CONFIG.timeout
  },
  (res) => {
    // Успех: 2xx (OK) или 3xx (редирект на /admin)
    if (res.statusCode >= 200 && res.statusCode < 400) {
      process.exit(0);
    } else {
      console.error(`Healthcheck failed: status ${res.statusCode}`);
      process.exit(1);
    }
  }
);

request.on('error', (err) => {
  console.error(`Healthcheck error: ${err.message}`);
  process.exit(1);
});

request.on('timeout', () => {
  request.destroy();
  console.error('Healthcheck timeout');
  process.exit(1);
});

request.end();

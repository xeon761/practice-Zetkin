'use strict';

module.exports = ({ env }) => ({
   auth: {
    secret: env('ADMIN_JWT_SECRET', 'default-admin-jwt-secret-change-in-production'),
  },
 
  apiToken: {
    salt: env('API_TOKEN_SALT', 'default-api-token-salt-change-in-production'),
  },
  
  transfer: {
    token: {
      salt: env('TRANSFER_TOKEN_SALT', 'default-transfer-token-salt-change-in-production'),
    },
  },
  
  server: {
    host: env('HOST', '0.0.0.0'),
    port: env.int('PORT', 1337),
  },
  
  url: env('ADMIN_URL', 'http://localhost/admin'),
});

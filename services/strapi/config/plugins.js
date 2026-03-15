{
  "dependencies": {
    "@strapi/strapi": "4.24.4",
    "@strapi/plugin-users-permissions": "4.24.4",
    "@strapi/plugin-i18n": "4.24.4",
    "@strapi/plugin-cloud": "4.24.4",
    "@strapi-community/plugin-healthcheck": "^1.0.0",
    "pg": "8.11.3"
  }
}
module.exports = ({ env }) => ({
  'plugin-healthcheck': {
    enabled: true,
    resolve: './src/plugins/healthcheck', // или '@strapi-community/plugin-healthcheck'
    config: {
      // Опционально: кастомные настройки
      endpoint: '/_health',
      checks: {
        database: true,  // проверять подключение к БД
        disk: false,     // не проверять место на диске
      }
    }
  },
});

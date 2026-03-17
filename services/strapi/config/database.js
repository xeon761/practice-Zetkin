module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST', 'postgres'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'strapi_dev'),
      user: env('DATABASE_USERNAME', 'devuser'),
      password: env('DATABASE_PASSWORD', 'devpass123'),
      schema: env('DATABASE_SCHEMA', 'public'),
    },
    debug: false,
  },
});

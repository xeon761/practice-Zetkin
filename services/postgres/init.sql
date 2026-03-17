CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS app_schema;

GRANT ALL PRIVILEGES ON SCHEMA app_schema TO devuser;

CREATE TABLE IF NOT EXISTS app_schema.health_check (
    id SERIAL PRIMARY KEY,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'healthy'
);

INSERT INTO app_schema.health_check (status) VALUES ('initialized');

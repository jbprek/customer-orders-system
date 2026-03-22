-- ============================================================
-- 01_schemas.sql  –  Schemas and per-service users
-- ============================================================

-- ── Schemas ───────────────────────────────────────────────
CREATE SCHEMA IF NOT EXISTS customer;
CREATE SCHEMA IF NOT EXISTS product;
CREATE SCHEMA IF NOT EXISTS orders;

-- ── Users ─────────────────────────────────────────────────
CREATE USER customer_user WITH PASSWORD 'customer_pass';
CREATE USER product_user  WITH PASSWORD 'product_pass';
CREATE USER orders_user   WITH PASSWORD 'orders_pass';

-- ── Database connect ──────────────────────────────────────
GRANT CONNECT ON DATABASE appdb TO customer_user, product_user, orders_user;

-- ── Schema usage ──────────────────────────────────────────
GRANT USAGE ON SCHEMA customer TO customer_user;
GRANT USAGE ON SCHEMA product  TO product_user;
GRANT USAGE ON SCHEMA orders   TO orders_user;

-- ── Default privileges (apply to tables created by postgres in 02_tables.sql) ──
ALTER DEFAULT PRIVILEGES IN SCHEMA customer
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES   TO customer_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA customer
    GRANT USAGE, SELECT                  ON SEQUENCES TO customer_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA product
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES   TO product_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA product
    GRANT USAGE, SELECT                  ON SEQUENCES TO product_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA orders
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES   TO orders_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA orders
    GRANT USAGE, SELECT                  ON SEQUENCES TO orders_user;

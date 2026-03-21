-- ============================================================
-- 02_tables.sql  –  DDL for all three services
-- ============================================================

-- ── customer schema ──────────────────────────────────────────

CREATE TABLE IF NOT EXISTS customer.customers (
    id         BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(100)        NOT NULL,
    last_name  VARCHAR(100)        NOT NULL,
    email      VARCHAR(255) UNIQUE NOT NULL,
    phone      VARCHAR(30),
    address    VARCHAR(500),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- ── product schema ───────────────────────────────────────────

CREATE TABLE IF NOT EXISTS product.products (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(255)        NOT NULL,
    description TEXT,
    price       NUMERIC(10, 2)      NOT NULL CHECK (price > 0),
    stock       INTEGER             NOT NULL CHECK (stock >= 0),
    sku         VARCHAR(100) UNIQUE,
    created_at  TIMESTAMP DEFAULT now(),
    updated_at  TIMESTAMP DEFAULT now()
);

-- ── orders schema ────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS orders.orders (
    id            BIGSERIAL PRIMARY KEY,
    customer_id   BIGINT          NOT NULL,
    status        VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    total_amount  NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    created_at    TIMESTAMP DEFAULT now(),
    updated_at    TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS orders.order_items (
    id           BIGSERIAL PRIMARY KEY,
    order_id     BIGINT         NOT NULL REFERENCES orders.orders (id) ON DELETE CASCADE,
    product_id   BIGINT         NOT NULL,
    product_name VARCHAR(255)   NOT NULL,
    quantity     INTEGER        NOT NULL CHECK (quantity > 0),
    unit_price   NUMERIC(10, 2) NOT NULL,
    subtotal     NUMERIC(10, 2) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON orders.order_items (order_id);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id   ON orders.orders (customer_id);

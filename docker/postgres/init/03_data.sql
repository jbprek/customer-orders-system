-- ============================================================
-- 03_data.sql  –  Sample data
-- ============================================================

-- ── Customers ────────────────────────────────────────────────

INSERT INTO customer.customers (first_name, last_name, email, phone, address) VALUES
    ('Alice',   'Johnson',  'alice.johnson@example.com',  '+1-555-0101', '123 Maple St, Springfield, IL 62701'),
    ('Bob',     'Smith',    'bob.smith@example.com',      '+1-555-0102', '456 Oak Ave, Chicago, IL 60601'),
    ('Carol',   'Williams', 'carol.williams@example.com', '+1-555-0103', '789 Pine Rd, Naperville, IL 60540'),
    ('David',   'Brown',    'david.brown@example.com',    '+1-555-0104', '321 Elm St, Evanston, IL 60201');

-- ── Products ─────────────────────────────────────────────────

INSERT INTO product.products (name, description, price, stock, sku) VALUES
    ('Laptop Pro 15',   'High-performance 15" laptop with 32GB RAM and 1TB SSD',       1299.99,  50, 'SKU-LAP-001'),
    ('Wireless Mouse',  'Ergonomic wireless mouse with 2-year battery life',               29.99, 200, 'SKU-MOU-002'),
    ('USB-C Hub',       '7-in-1 USB-C hub with HDMI, USB 3.0, and SD card reader',        49.99, 150, 'SKU-HUB-003'),
    ('Mechanical Keyboard', 'Compact TKL mechanical keyboard with RGB backlight',         89.99, 100, 'SKU-KEY-004'),
    ('Monitor 27"',     '4K IPS monitor 27 inch with 144Hz refresh rate',               499.99,  30, 'SKU-MON-005'),
    ('Webcam HD',       '1080p HD webcam with built-in noise-cancelling microphone',      79.99,  80, 'SKU-CAM-006');

-- ── Orders ───────────────────────────────────────────────────

INSERT INTO orders.orders (id, customer_id, status, total_amount) VALUES
    (1, 1, 'DELIVERED',  1409.96),
    (2, 2, 'PROCESSING',  169.98),
    (3, 3, 'PENDING',     499.99);

-- Sequence must stay in sync after explicit ID inserts
SELECT setval('orders.orders_id_seq', 3);

INSERT INTO orders.order_items (order_id, product_id, product_name, quantity, unit_price, subtotal) VALUES
    -- Order 1 (Alice): Laptop + Mouse + USB-C Hub
    (1, 1, 'Laptop Pro 15',  1, 1299.99, 1299.99),
    (1, 2, 'Wireless Mouse', 2,   29.99,   59.98),
    (1, 3, 'USB-C Hub',      1,   49.99,   49.99),
    -- Order 2 (Bob): Keyboard + Webcam
    (2, 4, 'Mechanical Keyboard', 1, 89.99,  89.99),
    (2, 6, 'Webcam HD',           1, 79.99,  79.99),
    -- Order 3 (Carol): Monitor
    (3, 5, 'Monitor 27"',         1, 499.99, 499.99);

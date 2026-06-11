-- =============================================
-- Лабораторна робота: OLAP - Створення схеми та VIEW
-- Бази даних та інформаційні системи
-- =============================================

-- КРОК 1: Створення бази даних
CREATE DATABASE olap_lab;

-- =============================================
-- КРОК 2: Створення таблиць
-- =============================================

-- Таблиця продуктів
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50)
);

-- Таблиця регіонів
CREATE TABLE regions (
  id SERIAL PRIMARY KEY,
  region_name VARCHAR(50),
  country VARCHAR(50)
);

-- Таблиця клієнтів
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  customer_name VARCHAR(100),
  segment VARCHAR(50)
);

-- Таблиця фактів (продажі)
CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  sale_date DATE,
  product_id INT,
  region_id INT,
  customer_id INT,
  quantity INT,
  revenue NUMERIC(10,2)
);

-- Додавання зовнішніх ключів
ALTER TABLE sales ADD FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE sales ADD FOREIGN KEY (region_id) REFERENCES regions(id);
ALTER TABLE sales ADD FOREIGN KEY (customer_id) REFERENCES customers(id);

-- =============================================
-- КРОК 3: Заповнення таблиць даними
-- =============================================

-- Заповнення продуктів
INSERT INTO products (product_name, category) VALUES
('Laptop', 'Electronics'),
('Phone', 'Electronics'),
('Monitor', 'Electronics'),
('Table', 'Furniture'),
('Chair', 'Furniture'),
('Desk Lamp', 'Furniture'),
('Notebook', 'Stationery'),
('Pen Set', 'Stationery'),
('Backpack', 'Accessories'),
('Headphones', 'Electronics');

-- Заповнення регіонів
INSERT INTO regions (region_name, country) VALUES
('Kyiv', 'Ukraine'),
('Lviv', 'Ukraine'),
('Odesa', 'Ukraine'),
('Warsaw', 'Poland'),
('Krakow', 'Poland');

-- Заповнення клієнтів
INSERT INTO customers (customer_name, segment) VALUES
('Company A', 'B2B'),
('Company B', 'B2B'),
('Company C', 'B2B'),
('Customer D', 'B2C'),
('Customer E', 'B2C'),
('Customer F', 'B2C');

-- Генерація 80 записів продажів
INSERT INTO sales (sale_date, product_id, region_id, customer_id, quantity, revenue)
SELECT
  DATE '2024-01-01' + (random() * 364)::INT,
  (random() * 9 + 1)::INT,
  (random() * 4 + 1)::INT,
  (random() * 5 + 1)::INT,
  (random() * 10 + 1)::INT,
  ROUND((random() * 5000 + 100)::NUMERIC, 2)
FROM generate_series(1, 80);

-- =============================================
-- КРОК 4: Створення VIEW
-- =============================================

CREATE VIEW orders_summary AS
SELECT
  DATE_PART('year', sale_date) AS year,
  DATE_PART('month', sale_date) AS month,
  p.category,
  r.region_name,
  r.country,
  c.segment,
  SUM(s.revenue) AS revenue,
  SUM(s.quantity) AS quantity
FROM sales s
JOIN products p ON s.product_id = p.id
JOIN regions r ON s.region_id = r.id
JOIN customers c ON s.customer_id = c.id
GROUP BY year, month, p.category, r.region_name, r.country, c.segment;

-- =============================================
-- Перевірка результату
-- =============================================

SELECT * FROM orders_summary 
ORDER BY year DESC, month DESC 
LIMIT 20;

-- Кількість рядків у VIEW
SELECT COUNT(*) AS total_rows FROM orders_summary;

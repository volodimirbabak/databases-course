-- =========================================================================
-- Лабораторна робота №4
-- Варіант 19: База даних для служби таксі
-- =========================================================================

-- 1. СТВОРЕННЯ КОРИСТУВАЦЬКОГО ТИПУ ДАНИХ (ENUM)
-- Створення типу для статусів поїздки
CREATE TYPE ride_status_enum AS ENUM ('pending', 'completed', 'cancelled');

-- Застосування типу до існуючої таблиці поїздок
ALTER TABLE rides 
ALTER COLUMN status TYPE ride_status_enum 
USING status::ride_status_enum;


-- 2. РЕАЛІЗАЦІЯ КОРИСТУВАЦЬКОЇ ФУНКЦІЇ
-- Функція для автоматичного підрахунку загального доходу конкретного водія
CREATE OR REPLACE FUNCTION get_driver_revenue(drv_id INT) 
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT SUM(price)
        FROM rides
        WHERE driver_id = drv_id AND status = 'completed'
    );
END;
$$ LANGUAGE plpgsql;


-- 3. СТВОРЕННЯ ТРИГЕРІВ ДЛЯ ЛОГУВАННЯ ТА АВТОМАТИЧНОГО ОНОВЛЕННЯ

-- А) Система логування змін (Аудит)
CREATE TABLE rides_log (
    log_id SERIAL PRIMARY KEY,
    ride_id INT,
    operation VARCHAR(10),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_ride_changes() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN 
        INSERT INTO rides_log (ride_id, operation) VALUES (OLD.ride_id, 'DELETE'); 
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN 
        INSERT INTO rides_log (ride_id, operation) VALUES (NEW.ride_id, 'UPDATE'); 
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN 
        INSERT INTO rides_log (ride_id, operation) VALUES (NEW.ride_id, 'INSERT'); 
        RETURN NEW;
    END IF; 
    RETURN NULL;
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_rides_audit 
AFTER INSERT OR UPDATE OR DELETE ON rides 
FOR EACH ROW EXECUTE FUNCTION log_ride_changes();


-- Б) Автоматичне оновлення лічильника поїздок у клієнта
ALTER TABLE clients ADD COLUMN total_rides INT DEFAULT 0;

CREATE OR REPLACE FUNCTION auto_update_client_rides() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE clients SET total_rides = total_rides + 1 WHERE client_id = NEW.client_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE clients SET total_rides = total_rides - 1 WHERE client_id = OLD.client_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auto_update_rides 
AFTER INSERT OR DELETE ON rides 
FOR EACH ROW EXECUTE FUNCTION auto_update_client_rides();

-- 1. Які водії працюють в службі таксі?
SELECT first_name, last_name, phone_number, car_brand, car_model 
FROM drivers;

-- 2. Скільки замовлень виконано кожним водієм? (Використання JOIN, GROUP BY та COUNT)
SELECT d.first_name, d.last_name, COUNT(r.ride_id) AS total_rides
FROM drivers d
JOIN rides r ON d.driver_id = r.driver_id
GROUP BY d.first_name, d.last_name;

-- 3. Яка середня відстань по кожному замовленню? (Використання AVG)
SELECT ROUND(AVG(distance_km), 2) AS avg_distance_km 
FROM rides;

-- 4. Скільки клієнтів зробили більше одного замовлення? (Використання GROUP BY, HAVING)
SELECT c.first_name, c.last_name, COUNT(r.ride_id) AS ride_count
FROM clients c
JOIN rides r ON c.client_id = r.client_id
GROUP BY c.first_name, c.last_name
HAVING COUNT(r.ride_id) > 1;

-- 5. Які клієнти витратили найбільше грошей на поїздки? (Використання SUM, ORDER BY DESC)
SELECT c.first_name, c.last_name, SUM(r.price) AS total_spent
FROM clients c
JOIN rides r ON c.client_id = r.client_id
WHERE r.status = 'completed'
GROUP BY c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 6. Яка середня вартість поїздки? (Використання AVG, WHERE)
SELECT ROUND(AVG(price), 2) AS avg_price 
FROM rides 
WHERE status = 'completed';

-- 7. Які замовлення здійснені в нічний час (після 22:00 або до 06:00)? (Використання WHERE)
SELECT ride_id, ride_date, distance_km, price 
FROM rides
WHERE EXTRACT(HOUR FROM ride_date) >= 22 OR EXTRACT(HOUR FROM ride_date) < 6;

-- 8. Скільки унікальних автомобілів (водіїв) виконували успішні поїздки? 
SELECT COUNT(DISTINCT driver_id) AS active_cars
FROM rides
WHERE status = 'completed';

-- 9. Які записи містять інформацію про скасування замовлення? (Використання JOIN, WHERE)
SELECT r.ride_id, c.first_name AS client_name, d.first_name AS driver_name, r.ride_date 
FROM rides r
JOIN clients c ON r.client_id = c.client_id
JOIN drivers d ON r.driver_id = d.driver_id
WHERE r.status = 'cancelled';

-- 10. Скільки поїздок виконано за певний період (з 1 по 3 травня)? 
SELECT COUNT(ride_id) AS rides_in_period
FROM rides
WHERE ride_date BETWEEN '2026-05-01' AND '2026-05-03 23:59:59';

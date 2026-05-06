-- Лабораторна робота №3
-- З дисципліни: Бази даних та інформаційні системи
-- Студента 3 курсу групи МІТ-31 Бабяка Володимира

/* ===============================================================
   ЧАСТИНА 1. ЛОГІЧНІ ОПЕРАТОРИ ТА БАЗОВА ВИБІРКА (1-5)
   =============================================================== */

-- Запит 1. Отримати всі поїздки, які були успішно завершені та коштували більше 200
SELECT * FROM rides 
WHERE status = 'completed' AND price > 200;

-- Запит 2. Знайти водіїв, які їздять на Toyota або Skoda
SELECT first_name, last_name, car_brand 
FROM drivers 
WHERE car_brand = 'Toyota' OR car_brand = 'Skoda';

-- Запит 3. Знайти клієнтів, чиї номери телефонів не починаються на '+38050'
SELECT first_name, last_name, phone_number 
FROM clients 
WHERE NOT phone_number LIKE '+38050%';

-- Запит 4. Вибрати поїздки з дистанцією від 5 до 15 км
SELECT * FROM rides 
WHERE distance_km BETWEEN 5 AND 15;

-- Запит 5. Знайти всіх клієнтів, у яких ім'я 'Олександр' або 'Марія'
SELECT * FROM clients 
WHERE first_name IN ('Олександр', 'Марія');

/* ===============================================================
   ЧАСТИНА 2. АГРЕГАТНІ ФУНКЦІЇ (COUNT, SUM, AVG, MIN, MAX) (6-10)
   =============================================================== */

-- Запит 6. Підрахувати загальну кількість скасованих поїздок
SELECT COUNT(*) AS cancelled_rides_count 
FROM rides 
WHERE status = 'cancelled';

-- Запит 7. Знайти загальну суму грошей, зароблену всіма водіями на успішних поїздках
SELECT SUM(price) AS total_revenue 
FROM rides 
WHERE status = 'completed';

-- Запит 8. Обчислити середню відстань усіх поїздок (з округленням до 2 знаків)
SELECT ROUND(AVG(distance_km), 2) AS avg_distance 
FROM rides;

-- Запит 9. Знайти мінімальну та максимальну вартість поїздки
SELECT MIN(price) AS min_price, MAX(price) AS max_price 
FROM rides;

-- Запит 10. Підрахувати кількість поїздок для кожного статусу
SELECT status, COUNT(ride_id) AS ride_count 
FROM rides 
GROUP BY status;

/* ===============================================================
   ЧАСТИНА 3. УСІ ТИПИ JOIN (11-17)
   =============================================================== */

-- Запит 11. INNER JOIN: Отримати імена клієнтів та дати їхніх поїздок
SELECT c.first_name, c.last_name, r.ride_date 
FROM clients c
INNER JOIN rides r ON c.client_id = r.client_id;

-- Запит 12. LEFT JOIN: Вивести всіх клієнтів і їхні поїздки (навіть якщо поїздок ще не було)
SELECT c.first_name, COUNT(r.ride_id) AS total_rides
FROM clients c
LEFT JOIN rides r ON c.client_id = r.client_id
GROUP BY c.first_name;

-- Запит 13. RIGHT JOIN: Вивести всіх водіїв і суму їхніх заробітків (навіть якщо вони ще не їздили)
SELECT d.first_name, SUM(r.price) AS earned_money
FROM rides r
RIGHT JOIN drivers d ON r.driver_id = d.driver_id
GROUP BY d.first_name;

-- Запит 14. FULL OUTER JOIN: Об'єднати дані клієнтів та поїздок повністю
SELECT c.first_name, r.ride_date, r.status
FROM clients c
FULL OUTER JOIN rides r ON c.client_id = r.client_id;

-- Запит 15. CROSS JOIN: Створити всі можливі комбінації пар "клієнт - водій"
SELECT c.first_name AS client, d.first_name AS driver 
FROM clients c
CROSS JOIN drivers d;

-- Запит 16. SELF JOIN: Знайти водіїв, які їздять на марках авто з однаковою першою літерою (наприклад, Toyota)
SELECT d1.first_name AS driver1, d2.first_name AS driver2, d1.car_brand
FROM drivers d1
JOIN drivers d2 ON d1.car_brand = d2.car_brand AND d1.driver_id != d2.driver_id;

-- Запит 17. Складний JOIN (3 таблиці): Детальна інформація про поїздку (Клієнт + Водій + Поїздка)
SELECT c.first_name AS client, d.first_name AS driver, r.distance_km, r.price
FROM rides r
JOIN clients c ON r.client_id = c.client_id
JOIN drivers d ON r.driver_id = d.driver_id;

/* ===============================================================
   ЧАСТИНА 4. СКЛАДНІ ПІДЗАПИТИ (WHERE, IN, EXISTS) (18-24)
   =============================================================== */

-- Запит 18. Підзапит у WHERE (IN): Водії, які виконали поїздки на дистанцію більше 15 км
SELECT first_name, last_name, car_brand 
FROM drivers 
WHERE driver_id IN (SELECT driver_id FROM rides WHERE distance_km > 15);

-- Запит 19. Підзапит (NOT IN): Клієнти, які ніколи не скасовували поїздки
SELECT first_name, last_name 
FROM clients 
WHERE client_id NOT IN (SELECT client_id FROM rides WHERE status = 'cancelled');

-- Запит 20. EXISTS: Знайти клієнтів, які здійснили хоча б одну поїздку дорожче 300
SELECT first_name, last_name 
FROM clients c 
WHERE EXISTS (
    SELECT 1 FROM rides r WHERE r.client_id = c.client_id AND r.price > 300
);

-- Запит 21. NOT EXISTS: Знайти водіїв, які не виконали жодної поїздки
SELECT first_name, last_name 
FROM drivers d 
WHERE NOT EXISTS (
    SELECT 1 FROM rides r WHERE r.driver_id = d.driver_id
);

-- Запит 22. Підзапит у SELECT: Вивести клієнта і відсоток його витрат від загальної суми всіх поїздок
SELECT first_name, 
       (SELECT SUM(price) FROM rides WHERE client_id = c.client_id) AS personal_spend,
       (SELECT SUM(price) FROM rides) AS total_all_spend
FROM clients c;

-- Запит 23. Підзапит у FROM: Знайти середній чек серед клієнтів, які витратили більше 200
SELECT ROUND(AVG(total_spent), 2) AS avg_top_spenders 
FROM (
    SELECT client_id, SUM(price) AS total_spent 
    FROM rides 
    GROUP BY client_id 
    HAVING SUM(price) > 200
) AS top_clients;

-- Запит 24. Вкладений підзапит (Глибокий): Клієнти, які їздили з водієм на 'Toyota'
SELECT first_name, last_name 
FROM clients 
WHERE client_id IN (
    SELECT client_id FROM rides WHERE driver_id IN (
        SELECT driver_id FROM drivers WHERE car_brand = 'Toyota'
    )
);

/* ===============================================================
   ЧАСТИНА 5. ОПЕРАЦІЇ НАД МНОЖИНАМИ (UNION, INTERSECT, EXCEPT) (25-28)
   =============================================================== */

-- Запит 25. UNION: Отримати єдиний список усіх номерів телефонів (клієнтів та водіїв)
SELECT phone_number, 'Client' AS role FROM clients
UNION
SELECT phone_number, 'Driver' AS role FROM drivers;

-- Запит 26. UNION ALL: Отримати всі імена з бази (включаючи дублікати)
SELECT first_name FROM clients
UNION ALL
SELECT first_name FROM drivers;

-- Запит 27. INTERSECT: Знайти імена, які зустрічаються і серед клієнтів, і серед водіїв
SELECT first_name FROM clients
INTERSECT
SELECT first_name FROM drivers;

-- Запит 28. EXCEPT: Знайти імена клієнтів, яких немає серед імен водіїв
SELECT first_name FROM clients
EXCEPT
SELECT first_name FROM drivers;

/* ===============================================================
   ЧАСТИНА 6. COMMON TABLE EXPRESSIONS (CTE) (29-34)
   =============================================================== */

-- Запит 29. Простий CTE: Вивести поїздки тільки успішних статусів
WITH CompletedRides AS (
    SELECT * FROM rides WHERE status = 'completed'
)
SELECT * FROM CompletedRides WHERE price > 150;

-- Запит 30. CTE з агрегацією: Знайти водіїв, які заробили більше середнього
WITH DriverEarns AS (
    SELECT driver_id, SUM(price) AS total_earned 
    FROM rides 
    GROUP BY driver_id
), 
AvgEarn AS (
    SELECT AVG(total_earned) AS avg_e FROM DriverEarns
)
SELECT d.first_name, de.total_earned 
FROM drivers d
JOIN DriverEarns de ON d.driver_id = de.driver_id
WHERE de.total_earned > (SELECT avg_e FROM AvgEarn);

-- Запит 31. CTE для підрахунку поїздок клієнта
WITH ClientRidesCount AS (
    SELECT client_id, COUNT(ride_id) AS num_rides
    FROM rides
    GROUP BY client_id
)
SELECT c.first_name, crc.num_rides
FROM clients c
JOIN ClientRidesCount crc ON c.client_id = crc.client_id
ORDER BY crc.num_rides DESC;

-- Запит 32. CTE: Найдорожча поїздка в базі
WITH MaxPriceRide AS (
    SELECT MAX(price) AS max_p FROM rides
)
SELECT * FROM rides WHERE price = (SELECT max_p FROM MaxPriceRide);

-- Запит 33. Складний CTE з JOIN: Деталі скасованих замовлень
WITH CancelledDetails AS (
    SELECT r.ride_id, r.client_id, r.driver_id, r.ride_date 
    FROM rides r WHERE status = 'cancelled'
)
SELECT cd.ride_id, c.first_name AS client, d.first_name AS driver
FROM CancelledDetails cd
JOIN clients c ON cd.client_id = c.client_id
JOIN drivers d ON cd.driver_id = d.driver_id;

-- Запит 34. Багатоступеневий CTE: Аналіз прибутковості по датах
WITH DailyRevenue AS (
    SELECT DATE(ride_date) AS ride_day, SUM(price) AS daily_total
    FROM rides
    WHERE status = 'completed'
    GROUP BY DATE(ride_date)
)
SELECT * FROM DailyRevenue ORDER BY daily_total DESC;

/* ===============================================================
   ЧАСТИНА 7. ВІКОННІ ФУНКЦІЇ (WINDOW FUNCTIONS) (35-40)
   =============================================================== */

-- Запит 35. OVER(): Показати вартість поїздки та загальну суму всіх поїздок поруч
SELECT ride_id, price, 
       SUM(price) OVER() AS grand_total 
FROM rides;

-- Запит 36. PARTITION BY: Середня вартість поїздки для кожного конкретного водія
SELECT ride_id, driver_id, price, 
       ROUND(AVG(price) OVER(PARTITION BY driver_id), 2) AS avg_driver_price 
FROM rides;

-- Запит 37. ROW_NUMBER(): Пронумерувати поїздки кожного клієнта за датою (від найпершої)
SELECT client_id, ride_id, ride_date, 
       ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY ride_date) AS ride_sequence 
FROM rides;

-- Запит 38. RANK(): Скласти рейтинг водіїв за кількістю виконаних поїздок
SELECT driver_id, COUNT(ride_id) AS rides_done,
       RANK() OVER(ORDER BY COUNT(ride_id) DESC) AS driver_rank
FROM rides 
WHERE status = 'completed'
GROUP BY driver_id;

-- Запит 39. DENSE_RANK(): Рейтинг поїздок за кілометражем (без пропусків місць)
SELECT ride_id, distance_km, 
       DENSE_RANK() OVER(ORDER BY distance_km DESC) AS distance_rank 
FROM rides;

-- Запит 40. LAG(): Аналіз трендів - порівняння ціни поточної поїздки з попередньою за часом
SELECT ride_id, ride_date, price, 
       LAG(price) OVER(ORDER BY ride_date) AS previous_ride_price,
       price - LAG(price) OVER(ORDER BY ride_date) AS price_difference
FROM rides;

-- Кінець файлу

CREATE DATABASE cinema_db;

CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    genre VARCHAR(50),
    duration_minutes INT
);

CREATE TABLE sessions (
    session_id SERIAL PRIMARY KEY,
    movie_id INT NOT NULL,
    session_time TIMESTAMP,
    hall_number INT,
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    session_id INT NOT NULL,
    seat_number INT,
    price DECIMAL(5, 2),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE
);

INSERT INTO movies (title, genre, duration_minutes) VALUES
('Дюна: Частина друга', 'Фантастика', 166),
('Дедпул і Росомаха', 'Бойовик', 127);

INSERT INTO sessions (movie_id, session_time, hall_number) VALUES
(1, '2026-05-10 18:00:00', 1),
(2, '2026-05-10 20:30:00', 2);

INSERT INTO tickets (session_id, seat_number, price) VALUES
(1, 15, 250.00),
(1, 16, 250.00),
(2, 10, 200.00);

UPDATE tickets SET price = 220.00 WHERE seat_number = 10;

SELECT m.title AS movie_name, s.session_time, t.seat_number, t.price
FROM tickets t
JOIN sessions s ON t.session_id = s.session_id
JOIN movies m ON s.movie_id = m.movie_id;

DELETE FROM tickets WHERE ticket_id = 1;

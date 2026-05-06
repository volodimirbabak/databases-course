CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20)
);

CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    car_brand VARCHAR(50),
    car_model VARCHAR(50),
    license_plate VARCHAR(20)
);

CREATE TABLE rides (
    ride_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    driver_id INT NOT NULL,
    ride_date TIMESTAMP,
    distance_km DECIMAL(5, 2),
    price DECIMAL(7, 2),
    status VARCHAR(20),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE
);

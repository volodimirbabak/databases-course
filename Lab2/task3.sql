CREATE USER admin_user WITH PASSWORD 'admin123';
CREATE USER moderator_user WITH PASSWORD 'moder123';
CREATE USER client_user WITH PASSWORD 'client123';

GRANT ALL PRIVILEGES ON DATABASE taxi_db TO admin_user;
GRANT CONNECT ON DATABASE taxi_db TO moderator_user, client_user;

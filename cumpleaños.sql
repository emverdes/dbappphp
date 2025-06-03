DROP DATABASE intranet IF EXISTS;
CREATE DATABASE intranet;
USE intranet;

CREATE TABLE cumpleaños (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha DATE
);

INSERT INTO cumpleaños (nombre, fecha) VALUES
('Ana Gómez', '1985-06-21'),
('Carlos Pérez', '1990-10-15');

CREATE USER 'intranet_user'@'%' IDENTIFIED BY 'claveSegura';
GRANT SELECT ON intranet.* TO 'intranet_user'@'%';
FLUSH PRIVILEGES;
EXIT;

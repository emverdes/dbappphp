DROP DATABASE intranet IF EXISTS;
CREATE DATABASE intranet;
USE intranet;

CREATE TABLE cumpleanios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha DATE
);

INSERT INTO cumpleanios (nombre, fecha) VALUES
('Francisco Polido', '2005-01-14'),
('Santiago Hoaguy', '2004-02-09'),
('Micaela Conde', '1994-12-09');

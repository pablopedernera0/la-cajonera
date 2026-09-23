-- =============================================================================
--  tienda.sql — mysql-joins-indices
--  Tablas chicas para aprender SELECT y JOIN: pocas filas, para poder ver
--  a ojo qué filas aparecen en cada JOIN y cuáles no.
--  Casos armados a propósito para el LEFT JOIN:
--    - Laura Paz (cliente 7) no hizo ningún pedido
--    - el producto 'Webcam HD' (producto 7) nunca se vendió
-- =============================================================================

CREATE DATABASE IF NOT EXISTS practica;
USE practica;

DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
  id        INT PRIMARY KEY AUTO_INCREMENT,
  nombre    VARCHAR(50) NOT NULL,
  apellido  VARCHAR(50) NOT NULL,
  ciudad    VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE productos (
  id        INT PRIMARY KEY AUTO_INCREMENT,
  nombre    VARCHAR(60) NOT NULL,
  categoria VARCHAR(30) NOT NULL,
  precio    DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE pedidos (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id  INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad    INT NOT NULL,
  fecha       DATE NOT NULL,
  FOREIGN KEY (cliente_id)  REFERENCES clientes(id),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
) ENGINE=InnoDB;

INSERT INTO clientes (nombre, apellido, ciudad) VALUES
  ('Juan',    'Pérez',    'Rosario'),
  ('María',   'Gómez',    'Funes'),
  ('Pedro',   'López',    'Rosario'),
  ('Lucía',   'Fernández','Santa Fe'),
  ('Martín',  'Sosa',     'Rosario'),
  ('Sofía',   'Díaz',     'Casilda'),
  ('Laura',   'Paz',      'Funes'),
  ('Diego',   'Romero',   'Rafaela');

INSERT INTO productos (nombre, categoria, precio) VALUES
  ('Notebook 14"',       'Computación',  850000.00),
  ('Mouse inalámbrico',  'Periféricos',   18500.00),
  ('Teclado mecánico',   'Periféricos',   62000.00),
  ('Monitor 24"',        'Computación',  210000.00),
  ('Switch 8 puertos',   'Redes',         45000.00),
  ('Router Wi-Fi 6',     'Redes',         98000.00),
  ('Webcam HD',          'Periféricos',   35000.00),
  ('Cable UTP Cat6 (3m)','Redes',          4500.00);

INSERT INTO pedidos (cliente_id, producto_id, cantidad, fecha) VALUES
  (1, 1, 1, '2026-08-03'),
  (1, 2, 2, '2026-08-03'),
  (2, 5, 1, '2026-08-05'),
  (2, 8, 10,'2026-08-05'),
  (3, 4, 2, '2026-08-11'),
  (4, 6, 1, '2026-08-12'),
  (4, 8, 4, '2026-08-12'),
  (5, 3, 1, '2026-08-20'),
  (5, 2, 1, '2026-08-20'),
  (6, 1, 1, '2026-09-01'),
  (8, 5, 2, '2026-09-02'),
  (8, 6, 1, '2026-09-02'),
  (3, 8, 6, '2026-09-10'),
  (1, 4, 1, '2026-09-15');

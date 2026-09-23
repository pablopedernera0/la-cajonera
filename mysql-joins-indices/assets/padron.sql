-- =============================================================================
--  padron.sql — mysql-joins-indices
--  Genera `localidades` (20 filas) y `padron` (@filas personas inventadas).
--  Uso: SET @filas = 3000000; SOURCE padron.sql;
--  Los datos son deterministas: el mismo @filas da las mismas filas en todas
--  las máquinas, así los resultados de los ejercicios se pueden corregir.
--  Todos los datos son inventados: no hay personas reales en este padrón.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS practica;
USE practica;

DROP TABLE IF EXISTS padron;
DROP TABLE IF EXISTS localidades;
DROP TABLE IF EXISTS numeros;

CREATE TABLE localidades (
  id           TINYINT PRIMARY KEY,
  nombre       VARCHAR(40) NOT NULL,
  departamento VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

INSERT INTO localidades (id, nombre, departamento) VALUES
  ( 1, 'Rosario',                 'Rosario'),
  ( 2, 'Funes',                   'Rosario'),
  ( 3, 'Villa Gobernador Gálvez', 'Rosario'),
  ( 4, 'Granadero Baigorria',     'Rosario'),
  ( 5, 'Pérez',                   'Rosario'),
  ( 6, 'Capitán Bermúdez',        'San Lorenzo'),
  ( 7, 'San Lorenzo',             'San Lorenzo'),
  ( 8, 'Casilda',                 'Caseros'),
  ( 9, 'Roldán',                  'San Lorenzo'),
  (10, 'Arroyo Seco',             'Rosario'),
  (11, 'Santa Fe',                'La Capital'),
  (12, 'Rafaela',                 'Castellanos'),
  (13, 'Venado Tuerto',           'General López'),
  (14, 'Reconquista',             'General Obligado'),
  (15, 'Cañada de Gómez',         'Iriondo'),
  (16, 'Esperanza',               'Las Colonias'),
  (17, 'Villa Constitución',      'Constitución'),
  (18, 'Firmat',                  'General López'),
  (19, 'Rufino',                  'General López'),
  (20, 'Totoras',                 'Iriondo');

-- Tabla auxiliar 0..9999: cruzándola consigo misma salen hasta 100 millones de filas
CREATE TABLE numeros (n INT PRIMARY KEY);
INSERT INTO numeros (n)
SELECT a.d + 10*b.d + 100*c.d + 1000*e.d
FROM (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
     (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
     (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
     (SELECT 0 d UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
      UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) e;

-- Sin índices a propósito (salvo la PK): los crea el alumno en el paso de índices.
-- Tampoco hay FOREIGN KEY sobre localidad_id: un FK crea un índice automáticamente.
CREATE TABLE padron (
  id               INT PRIMARY KEY,
  dni              INT NOT NULL,
  apellido         VARCHAR(40) NOT NULL,
  nombre           VARCHAR(40) NOT NULL,
  email            VARCHAR(100) NOT NULL,
  localidad_id     TINYINT NOT NULL,
  fecha_nacimiento DATE NOT NULL
) ENGINE=InnoDB;

INSERT INTO padron (id, dni, apellido, nombre, email, localidad_id, fecha_nacimiento)
SELECT
  x.id,
  10000000 + ((x.id * 7919) % 40000000),
  ELT(1 + CONV(LEFT(MD5(CONCAT('a', x.id)), 8), 16, 10) % 40,
      'González','Rodríguez','Gómez','Fernández','López','Díaz','Martínez','Pérez','García','Sánchez',
      'Romero','Sosa','Torres','Álvarez','Ruiz','Ramírez','Flores','Acosta','Benítez','Medina',
      'Suárez','Herrera','Aguirre','Pereyra','Gutiérrez','Giménez','Molina','Silva','Castro','Rojas',
      'Ortiz','Núñez','Luna','Juárez','Cabrera','Ríos','Ferreyra','Godoy','Morales','Domínguez'),
  ELT(1 + CONV(LEFT(MD5(CONCAT('n', x.id)), 8), 16, 10) % 40,
      'Juan','María','Pedro','Lucía','Martín','Sofía','Diego','Valentina','Lucas','Camila',
      'Mateo','Martina','Santiago','Julieta','Tomás','Agustina','Nicolás','Florencia','Facundo','Micaela',
      'Joaquín','Paula','Franco','Carolina','Ignacio','Victoria','Gonzalo','Milagros','Federico','Rocío',
      'Emiliano','Belén','Bruno','Aldana','Ramiro','Abril','Leandro','Candela','Maximiliano','Brenda'),
  CONCAT('persona', x.id, '@correo.com.ar'),
  1 + CONV(LEFT(MD5(CONCAT('l', x.id)), 8), 16, 10) % 20,
  DATE_ADD('1950-01-01', INTERVAL (CONV(LEFT(MD5(CONCAT('f', x.id)), 8), 16, 10) % 20000) DAY)
FROM (
  SELECT a.n * 10000 + b.n + 1 AS id
  FROM numeros a, numeros b
  WHERE a.n < CEIL(@filas / 10000)
) x
WHERE x.id <= @filas;

DROP TABLE numeros;
ANALYZE TABLE padron;

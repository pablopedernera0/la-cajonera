#### Conectando con la instancia de ejecución de Killercoda
Ahora que tenemos un servidor MySQL ejecutandose en conjunto con la aplicación PhpMyAdmin, podemos conectarnos a esta última mediante el puerto 8080

Hacemos click en el icono hamburger arriba a la derecha, se despliega un menú con las siguientes opciones:
- New Terminal Window
- New Editor Window
- Traffic / Ports
- Fon Size: 1 2 3 4 5 6 7 8

Si hacemos click en "Traffic / Ports", veremos una página con información.

Bajo el título Host1 -> Common Ports -> 8080 se encuentra el link para poder
 acceder a la instancia del host que estamos ejecutando.

El link se parece a algo así

https://eba91415-6f7a-489d-9913-5a263242fb25-10-244-3-65-80.saci.r.killercoda.com:8080/

si hacemos click en en el que aparece en nuestra pc, se abre una nueva pestaña
donde podremos verificar si los cambios que hicimos en la página web, se guardaron 
correctamente.


#### Ingresando a PhpMyAdmin
Si todo lo anterior se ejecutó normalmente, veremos la pantalla principal de PhpMyAdmin.

#### Ejecutando SQL en PhpMyAdmin
En la pantalla de PhpMyAdmin, sólo veremos las bases de datos del servidor MySQL y las necesarias para ejecutar PhpMyAdmin, pero todavía no veremos ninguna base de datos generada por nosotros.

Para crear una base datos debemos dirigirnos a la pestaña "SQL" y una allí copiar y pegar las siguientes sentencias SQL

<pre>
#Crear db
CREATE DATABASE alumnos;

#Crear tabla alumnos:
USE alumnos;

CREATE TABLE alumnos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL
);

#Esta tabla tiene una columna "id" como clave primaria y tres columnas más para el nombre, el apellido y la fecha de nacimiento de los alumnos.


#Crear tabla materias:
CREATE TABLE materias (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  calificacion FLOAT NOT NULL,
  alumno_id INT,
  FOREIGN KEY (alumno_id) REFERENCES alumnos(id)
);

#La tabla "materias" tiene una columna "id" como clave primaria y tres columnas más para el nombre de la materia, la calificación y la referencia al ID del alumno al que pertenece la calificación. La cláusula FOREIGN KEY establece la relación entre las tablas "alumnos" y "materias".



#Ahora, podemos insertar algunos datos en las tablas. Ejecuta el siguiente comando para insertar cinco registros de alumnos:
INSERT INTO alumnos (nombre, apellido, fecha_nacimiento)
VALUES
  ('Juan', 'Perez', '2000-01-01'),
  ('María', 'Gómez', '1999-05-15'),
  ('Pedro', 'López', '2001-10-20'),
  ('Ana', 'Martínez', '1998-03-08'),
  ('Luis', 'Rodríguez', '2002-07-12');

#Consulta basica, Esto te mostrará los nombres y apellidos de los alumnos que has insertado.:

SELECT nombre, apellido FROM alumnos;

#Datos para tabla materias:

INSERT INTO materias (nombre, calificacion, alumno_id)
VALUES
  ('Matemáticas', 8.5, 1),
  ('Historia', 7.2, 2),
  ('Ciencias', 9.0, 3),
  ('Literatura', 6.8, 4),
  ('Inglés', 8.9, 5);
</pre>

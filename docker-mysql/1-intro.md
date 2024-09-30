# MySQL y PhpMyAdmin con Docker
## Instalando MySQL y PhpMyAdmin dentro con Docker
### Autor: "Pablo Pedernera"
### Nivel: "Intermedio"

#### Docker Compose

Hemos visto que Docker se puede complementar con una herramienta de gestión de contenedores que se llama `docker compose` la cual es una herramienta que facilita la definición y ejecución de aplicaciones multicontenedor. Utiliza un archivo YAML (generalmente llamado docker-compose.yml) para configurar los servicios necesarios, lo que simplifica la gestión de aplicaciones complejas.

Con `docker compose` se pueden instalar de forma rápida y sencilla distintos containers, comunicados entre si mismos mediante una VLAN, que nos permitirán gestionar de forma muy sencilla nu servidor MySQL.

#### Que es MySQL
MySQL es un sistema de administración de bases de datos relacionales. Es un software de código abierto desarrollado por Oracle. Se considera como la base de datos de código abierto más utilizada en el mundo.

#### ¿Para qué sirve MySQL?

MySQL es uno de los sistemas más popularizados para almacenar y administrar datos. Con administrar nos referimos a las acciones CRUD:

    Create: crear
    Read: leer
    Update: actualizar
    Delete: borrar

#### Que es PhpAdmin
PhpMyAdmin es una aplicación web que sirve para administrar bases de datos MySQL de forma sencilla y con una interfaz amistosa. Se trata de un software muy popular basado en PHP. La ventaja de usar una aplicación web es que nos permite conectarnos con servidores remotos, a los cuales no siempre se puede acceder usando programas de interfaz gráfica.

#### ¿Para qué sirve PhpMyAdmin?
Con phpMyAdmin puedes hacer todo tipo de operaciones, desde la creación y borrado de bases de datos a la administración de las tablas (crear, modificar y eliminar) y, por supuesto, de sus propios datos.

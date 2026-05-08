# Nginx, MySQL, PhpMyAdmin y Flask con Docker
## Instalando Nginx, MySQL y PhpMyAdmin con Docker, y ejecutando una app con Flask
### Autor: "Pablo Pedernera"
### Nivel: "Intermedio"

#### Docker Compose

Hemos visto que Docker se puede complementar con una herramienta de gestión de contenedores que se llama `docker compose`, la cual facilita la definición y ejecución de aplicaciones multicontenedor. Utiliza un archivo YAML (generalmente llamado docker-compose.yml) para configurar los servicios necesarios, lo que simplifica la gestión de aplicaciones complejas.

Con `docker compose` se pueden instalar de forma rápida y sencilla distintos containers, comunicados entre sí mediante una VLAN, que nos permitirán gestionar un servidor MySQL, servir contenido web con NGINX, administrar la base de datos con PhpMyAdmin, y exponer una aplicación Python.

#### ¿Qué es NGINX?
NGINX es un servidor web de alto rendimiento, también utilizado como proxy inverso y balanceador de carga. Es ampliamente adoptado por su eficiencia para servir contenido estático y manejar grandes volúmenes de conexiones simultáneas.

#### ¿Qué es MySQL?
MySQL es un sistema de administración de bases de datos relacionales de código abierto desarrollado por Oracle. Se considera la base de datos de código abierto más utilizada en el mundo.

#### ¿Para qué sirve MySQL?

MySQL permite almacenar y administrar datos. Con administrar nos referimos a las acciones CRUD:

    Create: crear
    Read: leer
    Update: actualizar
    Delete: borrar

#### ¿Qué es PhpMyAdmin?
PhpMyAdmin es una aplicación web para administrar bases de datos MySQL de forma sencilla y con una interfaz amistosa. Está basada en PHP y permite conectarse con servidores remotos a los cuales no siempre se puede acceder mediante programas de interfaz gráfica.

#### ¿Para qué sirve PhpMyAdmin?
Con PhpMyAdmin podés hacer todo tipo de operaciones: desde la creación y borrado de bases de datos hasta la administración de tablas y sus datos.

#### ¿Qué es Flask?
Flask es un framework web minimalista para Python. Permite desarrollar aplicaciones web de forma rápida y sencilla, y es ideal para proyectos donde se necesita una solución liviana sin demasiada configuración.

#### ¿Qué vamos a hacer en esta práctica?
Al finalizar esta práctica vamos a tener cuatro servicios corriendo en Docker:

- **NGINX** sirviendo una página web estática en el puerto 80
- **MySQL** como motor de base de datos
- **PhpMyAdmin** para administrar MySQL desde el navegador en el puerto 8080
- **Una aplicación Flask** con un CRUD completo conectado a MySQL en el puerto 8888

Todo esto sin instalar nada directamente en el sistema operativo del host, solo ejecutando comandos de deploy.
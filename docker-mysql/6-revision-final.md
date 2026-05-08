#### Revisión final

#### Conectando con las instancias en ejecución de Killercoda

Ahora tenemos tres servicios corriendo al mismo tiempo:

- **NGINX** → puerto **80** → sirve la página HTML con la IP del servidor
- **PhpMyAdmin** → puerto **8080** → interfaz web para administrar MySQL
- **CRUD Python/Flask** → puerto **5600** → aplicación web de gestión de datos

Para acceder a cualquiera de ellos desde el navegador, hacemos click en el ícono hamburger arriba a la derecha y seleccionamos **"Traffic / Ports"**.

Allí encontraremos los links para cada puerto bajo **Host1 → Common Ports**.

#### ¿Qué podemos hacer en la aplicación CRUD?

La aplicación Flask que desplegamos permite:
- **Crear** nuevos registros en la base de datos
- **Leer** y listar los registros existentes
- **Actualizar** registros
- **Eliminar** registros

Todo esto sin haber escrito una sola línea de código nosotros. Solo clonamos un repositorio, configuramos la conexión con un comando, y levantamos el servicio.

#### Reflexión final

En esta práctica hemos:

1. Definido una infraestructura multicontenedor con `docker-compose.yml`
2. Levantado MySQL, PhpMyAdmin y NGINX con un solo comando
3. Ejecutado sentencias SQL desde la interfaz web de PhpMyAdmin
4. Desplegado una aplicación Python/Flask conectada a MySQL
5. Todo esto sin instalar nada directamente en el sistema operativo del host

Este es el flujo de trabajo real que se usa en entornos de desarrollo y producción modernos.
# ¡Escenario completado!

Instalaste y configuraste Docker desde cero, levantaste tu primer contenedor, orquestaste servicios con Docker Compose y 
personalizaste la página de bienvenida. ¡Bien hecho!

## Lo que hiciste

- **Instalación de Docker** — configuraste los repositorios oficiales, instalaste el motor y verificaste que el demonio esté activo
- **Primeros contenedores** — descargaste imágenes desde Docker Hub y ejecutaste contenedores tanto en primer como en segundo plano
- **Exposición de puertos** — mapeaste puertos del host al contenedor con el modificador `-p`
- **Docker Compose** — definiste un servicio NGINX mediante un archivo `docker-compose.yml` y lo levantaste con un único comando
- **Volúmenes** — montaste un directorio local dentro del contenedor para servir contenido estático personalizado
- **Página de bievenida** — editaste un archivo, que se usa como página principal de bienvenida del servidor nginx

## Comandos clave para recordar

| Comando                                   | Para qué sirve                                          |
|-------------------------------------------|---------------------------------------------------------|
| `docker run <imagen>`                     | Crear y ejecutar un contenedor                          |
| `docker run -d -p <host>:<cont> <imagen>` | Ejecutar en segundo plano y exponer un puerto           |
| `docker ps`                               | Listar contenedores en ejecución                        |
| `docker ps -a`                            | Listar todos los contenedores (incluidos los detenidos) |
| `docker images`                           | Ver imágenes descargadas localmente                     |
| `docker stop <id>`                        | Detener un contenedor                                   |
| `docker rm <id>`                          | Eliminar un contenedor                                  |
| `docker-compose up`                       | Levantar todos los servicios definidos en el YAML       |
| `docker-compose up -d`                    | Ídem, en segundo plano                                  |
| `docker-compose down`                     | Detener y eliminar los servicios                        |

## ¿Qué viene después?

En el próximo escenario vas a trabajar con un entorno más completo y realista:

- 🖥️ **Múltiples servidores** — vas a levantar varios contenedores y conectarlos entre sí mediante una red Docker
- 🌐 **Personalización** — vas a modificar la página de inicio del servidor web desde el host
- 🗄️ **Aplicación con base de datos** — vas a clonar un proyecto que implementa un CRUD básico y lo vas a poner en marcha con Docker Compose

¡Hasta la próxima!
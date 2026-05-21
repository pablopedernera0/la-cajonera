# ¡Escenario completado!

Aprendiste a escribir Markdown con nano, a levantar un entorno con Docker Compose y a visualizar el resultado en el navegador. ¡Excelente trabajo!

## Lo que hiciste

- **Markdown** — aprendiste la sintaxis básica: títulos, listas, tablas, código, énfasis y citas
- **nano** — usaste el editor de terminal para crear y modificar archivos de texto plano
- **Docker** — instalaste el motor de contenedores en Ubuntu desde los repositorios oficiales
- **Dockerfile** — creaste una imagen personalizada basada en NGINX con pandoc incluido
- **Docker Compose** — definiste y levantaste un servicio con un único archivo YAML
- **Volúmenes** — montaste un directorio local dentro del contenedor para compartir el archivo Markdown
- **pandoc** — convertiste Markdown a HTML con estilos desde dentro del contenedor
- **Ciclo edición → conversión → visualización** — comprendiste el flujo completo del proceso

## Comandos clave para recordar

| Comando                          | Para qué sirve                                         |
|----------------------------------|--------------------------------------------------------|
| `nano archivo.md`                | Abrir o crear un archivo con el editor nano            |
| `Ctrl + O` → `Enter`            | Guardar en nano                                        |
| `Ctrl + X`                       | Salir de nano                                          |
| `docker compose build`           | Construir la imagen definida en el Dockerfile          |
| `docker compose up -d`           | Levantar los servicios en segundo plano                |
| `docker compose restart`         | Reiniciar los servicios (para regenerar el HTML)       |
| `docker compose ps`              | Ver el estado de los servicios                         |
| `docker compose logs`            | Ver los logs de los contenedores                       |
| `docker compose down`            | Detener y eliminar los servicios                       |
| `curl http://localhost`          | Verificar que el servidor responde desde la terminal   |

## Sintaxis Markdown para llevarte

| Elemento        | Sintaxis                        |
|-----------------|---------------------------------|
| Título nivel 1  | `# Título`                      |
| Título nivel 2  | `## Título`                     |
| Negrita         | `**texto**`                     |
| Cursiva         | `*texto*`                       |
| Código inline   | `` `código` ``                  |
| Bloque código   | ` ```lenguaje ... ``` `         |
| Lista viñetas   | `- elemento`                    |
| Lista numerada  | `1. elemento`                   |
| Enlace          | `[texto](url)`                  |
| Tabla           | `\| col1 \| col2 \|`           |
| Separador       | `---`                           |
| Cita            | `> texto`                       |

## ¿Qué viene después?

En el próximo escenario vas a trabajar con un entorno más completo:

- 📝 **MkDocs** — generador de sitios de documentación basado en Markdown
- 🔄 **Recarga automática** — cada vez que guardés el archivo, el navegador se actualiza solo
- 🎨 **Temas y personalización** — configuración del aspecto del sitio documentado
- 🐙 **Integración con Git** — versionado de documentación como código

¡Hasta la próxima!

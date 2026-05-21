### Editando Markdown con nano

Es el momento de escribir nuestro primer documento Markdown real. Vamos a usar **nano**, el editor de texto de terminal más amigable para principiantes.

#### Breve guía de nano

Nano se maneja con atajos de teclado. Los más importantes:

| Atajo           | Acción                        |
|-----------------|-------------------------------|
| `Ctrl + O`      | Guardar el archivo            |
| `Enter`         | Confirmar el nombre al guardar|
| `Ctrl + X`      | Salir de nano                 |
| `Ctrl + K`      | Cortar una línea              |
| `Ctrl + U`      | Pegar línea cortada           |
| `Ctrl + W`      | Buscar texto                  |
| `Alt + U`       | Deshacer                      |
| `Ctrl + G`      | Ayuda                         |

> **Tip:** En la parte inferior de nano siempre se muestran los atajos disponibles. El símbolo `^` representa la tecla `Ctrl`.

#### Paso 1: Abrir el archivo con nano

`nano ~/markdown-lab/contenido/documento.md`{{exec}}

#### Paso 2: Escribir el contenido

Dentro de nano, escribí el siguiente contenido (podés copiarlo y pegarlo con `Ctrl + Shift + V` en la mayoría de terminales):

```markdown
# Infraestructura de Redes

## Introducción

Este documento fue creado con **Markdown** y editado con `nano` desde la terminal.

---

## Comandos Docker esenciales

A continuación, los comandos que más vas a usar:

| Comando                        | Descripción                        |
|--------------------------------|------------------------------------|
| `docker ps`                    | Lista contenedores activos         |
| `docker ps -a`                 | Lista todos los contenedores       |
| `docker images`                | Muestra imágenes descargadas       |
| `docker stop <id>`             | Detiene un contenedor              |
| `docker compose up -d`         | Levanta servicios en segundo plano |
| `docker compose down`          | Detiene y elimina los servicios    |

---

## ¿Qué es un contenedor?

Un contenedor es una **unidad estándar de software** que empaqueta el código
de una aplicación junto con todas sus dependencias.

Las ventajas principales son:

- **Aislamiento**: cada contenedor tiene su propio entorno
- **Portabilidad**: funciona igual en cualquier sistema
- **Eficiencia**: varios contenedores comparten el mismo kernel

---

## Ejemplo de Dockerfile

```dockerfile
FROM nginx:alpine
COPY ./web /usr/share/nginx/html
EXPOSE 80
```

---

## Recursos útiles

- [Documentación oficial de Docker](https://docs.docker.com)
- [Guía de Markdown](https://www.markdownguide.org)
- [Docker Hub](https://hub.docker.com)

---

> *"La infraestructura bien documentada es infraestructura que funciona."*
```

#### Paso 3: Guardar y salir

1. Presioná `Ctrl + O` para guardar
2. Presioná `Enter` para confirmar el nombre del archivo
3. Presioná `Ctrl + X` para salir de nano

#### Paso 4: Verificar que el archivo fue guardado

`cat ~/markdown-lab/contenido/documento.md`{{exec}}

Deberías ver el contenido que acabás de escribir.

#### Paso 5: Reiniciar el contenedor para regenerar el HTML

Cada vez que modifiques el archivo Markdown, necesitás reiniciar el contenedor para que `pandoc` vuelva a convertirlo:

`cd ~/markdown-lab && docker compose restart`{{exec}}

> **Nota:** En un entorno de producción esto se automatizaría con un *file watcher*. Por ahora lo hacemos manualmente para entender cada paso del proceso.

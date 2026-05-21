### Armando el entorno con Docker Compose

Vamos a crear un entorno que sirva nuestro archivo Markdown renderizado como HTML. Para eso usamos dos componentes:

- **NGINX**: servidor web que sirve los archivos al navegador
- **marked-cli** (vía una imagen Node): convierte el `.md` a `.html` automáticamente

En este escenario vamos a usar una imagen que combina ambas cosas en un único contenedor liviano, basado en NGINX con un script que convierte el Markdown al levantar el servicio.

#### Paso 1: Crear el directorio de trabajo

`mkdir -p ~/markdown-lab/contenido`{{exec}}

`cd ~/markdown-lab`{{exec}}

#### Paso 2: Crear el archivo docker-compose.yml

Vamos a generar el archivo de configuración de Docker Compose:

```
cat > ~/markdown-lab/docker-compose.yml << 'EOF'
services:
  markdown-viewer:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./contenido:/usr/share/nginx/html
    restart: unless-stopped
EOF
```{{exec}}

> **Recordá:** En YAML la indentación se hace con **espacios**, nunca con tabs.

#### Paso 3: Crear el script de conversión

Vamos a crear un script que convierte nuestro Markdown a HTML usando `pandoc` dentro del contenedor. Pero primero, necesitamos una imagen que incluya `pandoc`. Vamos a usar un Dockerfile simple:

```
cat > ~/markdown-lab/Dockerfile << 'EOF'
FROM nginx:alpine
RUN apk add --no-cache pandoc
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EOF
```{{exec}}

#### Paso 4: Crear el script entrypoint

Este script convierte el Markdown a HTML cada vez que el contenedor arranca:

```
cat > ~/markdown-lab/entrypoint.sh << 'EOF'
#!/bin/sh
set -e

CONTENT_DIR="/usr/share/nginx/html"
SOURCE_MD="/source/documento.md"

echo "Convirtiendo Markdown a HTML..."
pandoc "$SOURCE_MD" \
  --standalone \
  --metadata title="Mi Documento Markdown" \
  --css="https://cdn.jsdelivr.net/npm/github-markdown-css@5/github-markdown.min.css" \
  --to html5 \
  -o "$CONTENT_DIR/index.html"

echo "Conversion completada. Iniciando NGINX..."
nginx -g "daemon off;"
EOF
```{{exec}}

#### Paso 5: Actualizar docker-compose.yml para usar el Dockerfile

Ahora actualizamos el `docker-compose.yml` para usar nuestra imagen personalizada:

```
cat > ~/markdown-lab/docker-compose.yml << 'EOF'
services:
  markdown-viewer:
    build: .
    ports:
      - "80:80"
    volumes:
      - ./contenido:/source
    restart: unless-stopped
EOF
```{{exec}}

#### Paso 6: Construir y levantar el servicio

Primero vamos a crear el archivo Markdown inicial (lo editaremos en el siguiente paso):

`touch ~/markdown-lab/contenido/documento.md`{{exec}}

Construimos la imagen:

`cd ~/markdown-lab && docker compose build`{{exec}}

Levantamos el servicio:

`docker-compose up -d`{{exec}}

Verificamos que esté corriendo:

`docker-compose ps`{{exec}}

Deberías ver el servicio `markdown-viewer` con estado **running**.

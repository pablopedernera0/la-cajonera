### Docker Compose

#### Instalar Docker Compose


#### Crear un archivo 'docker-compose.yml'

Generar un arhcivo docker-compose.yml con el siguiente contenido

<pre>
version: '3'
services:
   web:
     image: nginx
     volumes:
       - ./web:/usr/share/nginx/html
     ports:
      - "80:80"
</pre>

`nano docker-compose.yml`{{exec}}

#### Generar el directorio local "web"

`mkdir web`{{exec}}

#### Ejecutar los servicios
`docker-compose up`{{exec}}

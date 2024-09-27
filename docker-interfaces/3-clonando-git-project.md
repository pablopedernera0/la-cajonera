#### Estructura de un archivo 'docker-compose.yml'

Recordemos que un archivo docker-compose.yml podía tener el siguiente contenido

<pre>
version: '3'
services:
   web:
     image: nginx
     ports:
      - "80:80"
</pre>

#### Añadiendo un directorio local compartido con el container

Empecemos por generar el directorio que vamos a compartir con el container

`mkdir web`{{exec}}

#### Modificar el archivo docker-compose.yml y agregar el 'volumen' compartido
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

#### Arrancando los servicios
`docker-compose up`{{exec}}


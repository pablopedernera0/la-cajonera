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

#### Generando un directorio
`mkdir web`{{exec}}

#### Generando el archivo docker-compose

Vamos a crear el archivo 'docker-compose.yml' que deberá tener el siguiente contenido

<pre>
version: '3'
services:
  mysql:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysecretpassword
    networks:
      - mynetwork

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    restart: always
    ports:
      - 8080:80
    environment:
      PMA_HOST: mysql
      PMA_USER: root
      PMA_PASSWORD: mysecretpassword
    depends_on:
      - mysql
    networks:
      - mynetwork
  web:
     image: nginx
     volumes:
       - ./web:/usr/share/nginx/html
     ports:
      - "80:80"
networks:
  mynetwork:
</pre>


`nano docker-compose.yml`{{exec}}


#### Arrancando los servicios
`docker-compose up -d`{{exec}}

Una vez que que se completa la ejecución del comando anterior, tendremos un sevidor MySQL y la aplicación PhpMyAdmin ejecutandose, conectados entre sí mediante un VLAN.

Para corrobar, podemos ejecutar 
`docker ps`{{exec}}

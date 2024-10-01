#### Estructura de un archivo 'docker-compose.yml'

Recordemos que un archivo docker-compose.yml podía tener el siguiente contenido

<pre>
version: '3'
services:
  mongodb:
    image: mongo:4.0.5
    ports:
      - 27017:27017
    volumes:
      - mongodb_data:/data/db

  mongo-express:
    image: mongo-express
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_MONGODB_SERVER=mongodb
      - ME_CONFIG_MONGODB_PORT=27017
    depends_on:
      - mongodb

volumes:
  mongodb_data:
</pre>


`nano docker-compose.yml`{{exec}}


#### Arrancando los servicios
`docker-compose up -d`{{exec}}

Una vez que que se completa la ejecución del comando anterior, tendremos un sevidor MongoDB y la aplicación Mongo Express ejecutandose, conectados entre sí mediante un VLAN.

Para corrobar, podemos ejecutar 
`docker ps`{{exec}}

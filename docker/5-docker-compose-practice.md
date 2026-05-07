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

```
cat > docker-compose.yml << 'EOF'
services:
   web:
     image: nginx
     volumes:
       - ./web:/usr/share/nginx/html
     ports:
      - "80:80"
EOF
```
> **Importante:** En YAML la indentación es parte de la sintaxis. Usá siempre espacios, nunca tabs.

#### Generar el directorio local "web"

`mkdir web`{{exec}}

#### Ejecutar los servicios
`docker-compose up`{{exec}}

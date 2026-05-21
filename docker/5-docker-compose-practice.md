### Docker Compose

#### Trabajando con Docker Compose


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
Vamos a generar un archivo en el directorio web, lo necesitamos para lo que sigue

`mkdir web`{{exec}}

#### Creando la página de bienvenida
Ya tenemos el servidor NGINX casi listo, antes de ponerlo a funcionaar, vamos a personalizar la página de bienvenida.

Vamos a generar un archivo vacío

`touch web/index.html`{{exec}}

y dentro vamos a colocar el siguiente contenido

```html
<!DOCTYPE html>
 <html lang="en">
 <head>
     <meta charset="UTF-8">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>Server IP Address</title>
     <script>
         async function fetchServerIP() {
             try {
                 // Fetching the IP address from a public API
                 const response = await fetch('https://api.ipify.org?format=json');
                 const data = await response.json();
                 // Displaying the IP address in the HTML
                 document.getElementById('ipAddress').textContent = data.ip;
             } catch (error) {
                 console.error('Error fetching IP address:', error);
                 document.getElementById('ipAddress').textContent = 'Unable to retrieve IP address';
             }
         }
 
         // Call the function when the window loads
         window.onload = fetchServerIP;
     </script>
 </head>
 <body>
     <h1>Your Server IP Address:</h1>
     <p id="ipAddress">Loading...</p>
 </body>
 </html>
```

Para editar el archivo, que está vacío, y ponerle el contanido podemos ejecutar el siguiente comando, y luego pegar el contenido
anterior

`nano web/index.html`{{exec}}

#### Ejecutar los servicios

Ahora si, arrancamos el container

`docker-compose up -d`{{exec}}

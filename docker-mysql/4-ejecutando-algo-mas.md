#### Vamos a ejecutar algo mas
Ahora que tenemos un servidor NGINX ejecutandose, vamos a ver cual es la direccion ip

Vamos a generar un archivo en el directorio web

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

Para generar el archivo podemos ejecutar el comando

`nano web/index.html`{{exec}}
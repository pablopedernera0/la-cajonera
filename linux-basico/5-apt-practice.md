### Actividad Práctica: Instalar y remover paquetes en linux

#### Actualizar repositorios

`apt update`{{exec}}

#### Instalar editor nano
`apt install nano`{{exec}}

#### Comprobar que nano se instalo correctamente
`nano archivo-de-texto.txt`{{exec}}

#### Instalar ping
`apt install inetutils-ping`{{exec}}

#### Comprobar que ping se instalo correctamente
`ping google.com`{{exec}}

#### Instalar el servidor web nginx
`apt install nginx`{{exec}}

#### Comprobar que nginx se instalo correctamente
`sevice nginx status`{{exec}}

#### Editar la pagina web que ngnix muestra por default
`nano /var/www/html/index.nginx-debian.html`{{exec}}

Cambiar el texto, agregando nuestro nombre y apellido, y cualquier otro
texto que se nos ocurra.

Cerrar el editor nano presionando ctrl + x y respondiendo que si (yes) a la 
pregunta sobre si queremos guardar los cambios

#### Comprobar que los cambios se guardaron correctamente
Al hacer click en el icono hamburger arriba a la derecha, se despliega
un menú con las siguientes opciones:
- New Terminal Window
- New Editor Window
- Traffic / Ports
- Fon Size: 1 2 3 4 5 6 7 8

Si hacemos click en "Traffic / Ports", veremos una página con información.

Bajo el título Host1 -> Common Ports -> 80 se encuentra el link para poder
 acceder a la instancia del host que estamos ejecutando.

El link se parece a algo así

https://eba91415-6f7a-489d-9913-5a263242fb25-10-244-3-65-80.saci.r.killercoda.com/

si hacemos click en en el que aparece en nuestra pc, se abre una nueva pestaña
donde podremos verificar si los cambios que hicimos en la página web, se guardaron 
correctamente.
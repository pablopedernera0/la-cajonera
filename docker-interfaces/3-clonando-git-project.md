#### Clonando un proyecto git dentro en el host

Ahora vamos a clonar un repositorio git dentro del directorio web

`cd web`{{exec}}

`git clone https://github.com/pablopedernera0/interfaces.git`{{exec}}


#### Comprobando que todo funciona

Si la ejecución de los comandos anteriores funcionó con normalidad, al hacer click en el icono hamburger arriba a la derecha, se despliega un menú con las siguientes opciones:
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

IMPORTANTE: como nuestro proyecto git se 'clona' en el directorio 'interfaces' hay que agregar esta carpeta al final de la url temporal que nos provee killercoda


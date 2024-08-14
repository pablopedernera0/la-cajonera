### Actividad Práctica: Navegación y Manipulación de Archivos

En esta actividad, crearás directorios y archivos, listarás contenido, moverás y copiarás archivos, y eliminarás archivos y directorios."

Como vimos, el comando "mkdir" sirve para crear un directorio, en este caso en el directorio en el que nos encontremos

`mkdir un_directorio`{{exec}}

Con el comando "cd" podemos ingresar en el directorio recien creado

`cd un_directorio`{{exec}}

El comando touch genera un archivo vacío, en este caso "archivo.txt"

`touch archivo.txt`{{exec}}

El comando ls nos permite ver el contenido del directorio o carpeta

`ls -lh`{{exec}}

El comando "cat" muestra por pantalla un archivo. También se puede usar para concatenar varios archivos y mostrarlos por pantalla

`cat archivo.txt`{{exec}}

Obviamente el archivo está vacío, por eso no vemos nada, vamos a poner algo de contenido en él.

Para ello vamos a utilizar una función muy útil de linux, la redirección de la salida estándar

## Redirección de Salida y "Pipe" en Linux

### Redirección de Salida
La redirección de salida en Linux permite enviar la salida de un comando a un archivo o a otro comando, en lugar de mostrarla en la terminal. Esto se logra utilizando operadores como `>`, `>>`, y `<`.

- **`>`**: Redirige la salida estándar a un archivo, sobrescribiendo su contenido si ya existe. Ejemplo:
  
`echo "Hola Mundo" > archivo.txt`{{exec}}

Esto escribe "Hola Mundo" en archivo.txt

>>: Similar a >, pero en lugar de sobrescribir, añade la salida al final del archivo si ya existe. 

Ejemplo:
`echo "Otra línea" >> archivo.txt`{{exec}}

<: Redirige la entrada estándar desde un archivo. 

Ejemplo:
`wc -l < archivo.txt`{{exec}}

### grep

El comando `grep` (Global Regular Expression Print) es una herramienta poderosa en Linux utilizada para buscar texto dentro de archivos o salidas de comandos. `grep` filtra líneas de texto que coinciden con un patrón específico, utilizando expresiones regulares para realizar búsquedas avanzadas.

### Uso Básico
La sintaxis básica de `grep` es:

grep [opciones] 'patrón' [archivo]

Ejemplos:
Buscar una palabra en un archivo:

`grep "Hola" archivo.txt`{{exec}}

Esto busca la palabra "Hola" en archivo.txt y muestra las líneas que coinciden.

Mostrar líneas que no coinciden con el patrón:

`grep -v "Hola" archivo.txt`{{exec}}

La opción -v invierte la búsqueda, mostrando las líneas que no contienen la palabra "Hola".

Mostrar el número de línea donde se encuentra el patrón:

`grep -n "Hola" archivo.txt`{{exec}}

La opción -n muestra el número de línea junto con la línea que coincide.

Buscar recursivamente en un directorio:

grep -r "Hola" /ruta/al/directorio

La opción -r permite buscar en todos los archivos dentro de un directorio y sus subdirectorios.

#### Expresiones Regulares

grep soporta expresiones regulares, lo que permite realizar búsquedas avanzadas, como buscar patrones de texto más complejos.

`grep "^[Hh]ola" archivo.txt`run{{exec}}


### Pipe

No es un comando en si mismo, pero "pipe" es una utilidad muy usada en linux.

El operador "pipe" (|) en Linux se utiliza para encadenar comandos, redirigiendo la salida de un comando como entrada de otro. 

Es útil para procesar datos de manera secuencial.

`ls -l | grep "archivo"`{{exec}}

En este ejemplo, la salida del comando ls -l (una lista detallada de archivos) se pasa como entrada al comando grep "archivo", que filtra y muestra solo las líneas que contienen la palabra "archivo".

El uso de pipes permite combinar comandos simples para realizar tareas más complejas de manera eficiente, aprovechando la filosofía de Unix de utilizar múltiples herramientas pequeñas para resolver problemas específicos.




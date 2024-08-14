###Interfaz de Línea de Comandos (CLI)",

La CLI es una herramienta poderosa en Linux. Aprenderemos comandos básicos como `ls`, `cd`, `mkdir`, `rm`, y cómo redirigir la entrada/salida

## Descripción de comandos mencionados: `mkdir`, `cd`, `touch`, `ls`

### 1. `mkdir` (Make Directory)
Este comando se utiliza para crear nuevos directorios (carpetas) en el sistema de archivos. Por ejemplo, `mkdir nueva_carpeta` creará una carpeta llamada "nueva_carpeta" en el directorio actual. Se pueden crear directorios anidados utilizando la opción `-p`, como en `mkdir -p carpeta1/carpeta2`.

### 2. `cd` (Change Directory)
El comando `cd` permite cambiar de directorio dentro del sistema de archivos. Por ejemplo, `cd /home/usuario` te llevará al directorio "/home/usuario". Usar `cd ..` te moverá al directorio padre, y `cd ~` te llevará al directorio de inicio del usuario.

### 3. `touch`
El comando `touch` se utiliza principalmente para crear archivos vacíos o actualizar la fecha de modificación de un archivo existente. Por ejemplo, `touch archivo.txt` creará un archivo vacío llamado "archivo.txt" si no existe, o actualizará su timestamp si ya existe.

### 4. `ls` (List)
`ls` muestra el contenido de un directorio. Sin opciones, `ls` lista los archivos y carpetas en el directorio actual. Con opciones como `-l` (lista detallada), `-a` (incluye archivos ocultos), o `-h` (formato legible para humanos), se puede personalizar la salida. Por ejemplo, `ls -la` muestra todos los archivos, incluidos los ocultos, con detalles como permisos, propietario y tamaño.

Estos comandos son fundamentales para la navegación y gestión de archivos en un sistema Linux.

### 5. `man` (Manual Pages)

El comando `man` (abreviatura de "manual") se utiliza en Linux para mostrar las páginas del manual de otros comandos o programas del sistema. Es una herramienta esencial para obtener información detallada sobre el uso, opciones, y funcionamiento de comandos específicos. 

#### Uso Básico
Para usar `man`, simplemente escribe `man` seguido del nombre del comando sobre el cual deseas obtener información. Por ejemplo:

`man ls`{{exec}}

#### Estructura de una Página de Manual

Las páginas de man están estructuradas en secciones, que suelen incluir:

    NAME: Nombre del comando o programa.
    SYNOPSIS: Sintaxis básica del comando.
    DESCRIPTION: Descripción detallada de lo que hace el comando.
    OPTIONS: Opciones o flags que se pueden utilizar con el comando.
    EXAMPLES: Ejemplos de uso.
    SEE ALSO: Comandos o recursos relacionados.

#### Atajos de Teclado Comunes en man

    q: Salir de la página del manual.
    /palabra: Buscar una palabra clave dentro del manual.
    n: Ir al siguiente resultado de búsqueda.
    h: Mostrar ayuda sobre el uso de man.

El comando man es invaluable para aprender a utilizar las herramientas de Linux, ya que proporciona documentación oficial y detallada directamente desde la línea de comandos.
### Gestión de Paquetes

En esta lección aprenderemos sobre la gestión de paquetes en Linux, incluyendo cómo instalar, actualizar y eliminar paquetes usando `apt`.

Para otras versiones de linux existen otros gestores de paquetes como `yum` o `dnf`.

#### Descripción del Comando Linux: `apt`

El comando `apt` es una herramienta de línea de comandos utilizada para gestionar paquetes de software en distribuciones de Linux basadas en Debian, como **Ubuntu**. Es una interfaz simplificada para interactuar con el sistema de paquetes **APT (Advanced Package Tool)**, que facilita la instalación, actualización, eliminación y gestión de paquetes de software.

####
 Uso Básico
La sintaxis básica de `apt` es:

```bash
apt [opción] [comando] [paquete]
```
##### Actualizar la lista de paquetes:
```bash
sudo apt update
```
Este comando actualiza la lista local de paquetes disponibles desde los repositorios configurados. Es el primer paso antes de instalar o actualizar cualquier paquete.

##### Actualizar todos los paquetes instalados:
```bash
sudo apt upgrade
```
Este comando instala las versiones más recientes de todos los paquetes instalados en el sistema, si están disponibles en los repositorios.

##### Instalar un paquete:
```bash
sudo apt install nombre_paquete
```
Instala el paquete especificado, junto con cualquier dependencia necesaria.

##### Eliminar un paquete:

```bash
sudo apt remove nombre_paquete
```
Elimina el paquete especificado, pero mantiene los archivos de configuración.

##### Eliminar un paquete junto con sus archivos de configuración:
```bash
sudo apt purge nombre_paquete
```
Este comando elimina el paquete y sus archivos de configuración, dejando el sistema limpio.

##### Buscar un paquete en los repositorios:
```bash
apt search nombre_paquete
```
Busca paquetes en los repositorios que coincidan con el término de búsqueda.

##### Mostrar información detallada de un paquete:
```bash
apt show nombre_paquete
```
Muestra información detallada sobre un paquete, incluyendo su descripción, tamaño, dependencias, y más.

##### Limpiar paquetes descargados y no utilizados:
```bash
sudo apt autoremove
sudo apt clean

```

`autoremove` elimina paquetes instalados automáticamente que ya no son necesarios, y `clean` limpia el caché de paquetes descargados.

#### Diferencias con apt-get

El comando `apt` es una versión más moderna e intuitiva de `apt-get` y `apt-cache`, ofreciendo una interfaz unificada y comandos más sencillos para tareas comunes. 
Aunque `apt-get` sigue disponible y es completamente funcional, `apt` está diseñado para ser más fácil de usar para los usuarios habituales.
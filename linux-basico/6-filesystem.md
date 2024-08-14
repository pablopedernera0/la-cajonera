## "Sistema de Archivos"

En esta sección comprenderemos la estructura del sistema de archivos en Linux y los directorios importantes como `/`, `/home`, `/etc`, y más.

## Principales Directorios en Linux

El sistema de archivos de Linux está organizado en una estructura jerárquica de directorios, comenzando con la raíz (`/`). A continuación se describen algunos de los directorios más importantes:

### 1. `/`
- **Descripción**: Es la raíz del sistema de archivos, el punto de inicio de toda la estructura de directorios. Todos los demás directorios y archivos están contenidos o enlazados desde aquí.

### 2. `/bin`
- **Descripción**: Contiene binarios esenciales (programas ejecutables) necesarios para el funcionamiento básico del sistema, como `ls`, `cp`, `mv`, entre otros. Estos comandos están disponibles tanto para el usuario como para el sistema en el arranque.

### 3. `/sbin`
- **Descripción**: Similar a `/bin`, pero contiene binarios y comandos esenciales utilizados principalmente por el administrador del sistema (root), como `ifconfig`, `reboot`, entre otros.

### 4. `/etc`
- **Descripción**: Almacena archivos de configuración del sistema. Aquí se encuentran configuraciones importantes como `/etc/passwd` para la gestión de usuarios, `/etc/fstab` para la tabla de sistemas de archivos, y muchos otros archivos de configuración de servicios y aplicaciones.

### 5. `/home`
- **Descripción**: Directorio que contiene los directorios personales de cada usuario. Por ejemplo, `/home/usuario` es el directorio personal del usuario "usuario", donde este almacena sus archivos personales, configuraciones, y más.

### 6. `/var`
- **Descripción**: Contiene archivos variables, como registros de sistema (logs), archivos de cola de impresión, y otros datos que cambian con el tiempo. Un ejemplo común es `/var/log`, donde se almacenan los archivos de registro.

### 7. `/usr`
- **Descripción**: Contiene aplicaciones y utilidades del usuario, además de bibliotecas, documentación y otros recursos. Subdirectorios importantes incluyen `/usr/bin` para binarios adicionales, y `/usr/lib` para bibliotecas de software.

### 8. `/tmp`
- **Descripción**: Directorio temporal donde las aplicaciones pueden almacenar archivos temporales. Los archivos en `/tmp` suelen ser eliminados automáticamente al reiniciar el sistema.

### 9. `/lib`
- **Descripción**: Almacena bibliotecas compartidas y módulos del kernel necesarios para que los binarios en `/bin` y `/sbin` funcionen correctamente.

### 10. `/opt`
- **Descripción**: Usado para instalar software adicional de forma opcional. Muchas aplicaciones de terceros y paquetes comerciales se instalan aquí.

### 11. `/boot`
- **Descripción**: Contiene archivos necesarios para el arranque del sistema, como el kernel de Linux, la imagen de initrd y el cargador de arranque (GRUB).

### 12. `/dev`
- **Descripción**: Contiene archivos de dispositivo que representan hardware del sistema, como discos duros, terminales y dispositivos de entrada/salida.

### 13. `/mnt` y `/media`
- **Descripción**: Directorios utilizados para montar temporalmente sistemas de archivos, como unidades USB o particiones adicionales. `/mnt` es tradicionalmente para montajes temporales, mientras que `/media` suele usarse para medios extraíbles.

Estos directorios forman la base del sistema de archivos de Linux y son fundamentales para la organización y funcionamiento del sistema operativo.

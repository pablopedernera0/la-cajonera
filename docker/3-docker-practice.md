### Instalando Docker en Ubuntu

#### Paso 1: Instalar Docker

Instalar algunos paquetes de requisitos previos que permitan a apt usar paquetes a través de HTTPS:

`sudo apt install apt-transport-https ca-certificates curl software-properties-common`{{exec}}

Añadir la clave de GPG para el repositorio oficial de Docker en el sistema:

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`{{exec}}

Agregar el repositorio de Docker a las fuentes de APT:

`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"`{{exec}}

Actualizar los paquetes

`sudo apt update`{{exec}}

Asegurarse de estar a punto de realizar la instalación desde el repositorio de Docker en lugar del repositorio predeterminado de Ubuntu:
`apt-cache policy docker-ce`{{exec}}

Si bien el número de versión de Docker puede ser distinto, se verá un resultado como el siguiente:

`docker-ce:
Installed: (none)
Candidate: 5:19.03.9~3-0~ubuntu-focal
Version table:
5:19.03.9~3-0~ubuntu-focal 500
500 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages
`

Por último, instalar Docker:

`sudo apt install docker-ce`{{exec}}

Con esto, Docker quedará instalado, el demonio se iniciará y el proceso se habilitará para ejecutarse en el inicio. 
Comprobar que funciona:

`sudo systemctl status docker`{{exec}}

El resultado debe ser similar al siguiente, y mostrar que el servicio está activo y en ejecución:

`● docker.service - Docker Application Container Engine
Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
Active: active (running) since Tue 2020-05-19 17:00:41 UTC; 17s ago
TriggeredBy: ● docker.socket
Docs: https://docs.docker.com
Main PID: 24321 (dockerd)
Tasks: 8
Memory: 46.4M
CGroup: /system.slice/docker.service
└─24321 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock`

#### Paso 2 : Ejecutar el comando Docker sin sudo (opcional)

Por defecto, el comando docker solo puede ser ejecutado por el usuario root o un usuario del grupo docker, que se crea automáticamente durante el proceso de instalación de Docker. 
Si se intenta ejecutar el comando docker sin sudo como prefijo o sin formar parte del grupo docker, se obtendrá un resultado como este:

`Output
docker: Cannot connect to the Docker daemon. Is the docker daemon running on this host?.
See 'docker run --help'.`

Si desea evitar escribir sudo al ejecutar el comando docker, hay agregar el nombre de usuario actual al grupo docker:

`sudo usermod -aG docker ${USER}`{{exec}}

Luego ejecutar el siguiente comando

`su - ${USER}`{{exec}}

Para continuar, se le solicitará ingresar la contraseña de su usuario.

Confirme que ahora su usuario se agregó al grupo docker escribiendo lo siguiente:

`id -nG`{{exec}}

`
sammy sudo docker
`

#### Paso 3: Usar el comando docker

El uso de docker consiste en pasar a este una cadena de opciones y comandos seguida de argumentos. La sintaxis adopta esta forma:

`docker [option] [command] [arguments]`

Para ver todos los subcomandos disponibles, escriba lo siguiente:

`docker`{{exec}}

#### Paso 4: Trabajar con imágenes de Docker
Los contenedores de Docker se construyen con imágenes de Docker. Por defecto, Docker obtiene estas imágenes de Docker Hub, un registro de Docker gestionado por Docker, la empresa responsable del proyecto Docker. Cualquiera puede alojar sus imágenes en Docker Hub, de modo que la mayoría de las aplicaciones y las distribuciones de Linux que necesitará tendrán imágenes alojadas allí.

Para verificar si puede acceder a imágenes y descargarlas de Docker Hub, escriba lo siguiente:

`docker run hello-world` {{exec}}

El resultado indicará que Docker funciona de forma correcta:

`Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete
Digest: sha256:6a65f928fb91fcfbc963f7aa6d57c8eeb426ad9a20c7ee045538ef34847f44f1
Status: Downloaded newer image for hello-world:latest
Hello from Docker!
This message shows that your installation appears to be working correctly.
...`

Inicialmente, Docker no pudo encontrar la imagen de hello-world a nivel local. Por ello la descargó de Docker Hub, el repositorio predeterminado. Una vez que se descargó la imagen, Docker creó un contenedor a partir de ella y de la aplicación dentro del contenedor ejecutado, y mostró el mensaje.

Puede buscar imágenes disponibles en Docker Hub usando el comando docker con el subcomando search. Por ejemplo, para buscar la imagen de Ubuntu, escriba lo siguiente:

`docker search ubuntu`{{exec}}

La secuencia de comandos rastreará Docker Hub y mostrará una lista de todas las imágenes cuyo nombre coincida con la cadena de búsqueda.

#### Paso 5: Ejecutar un contenedor de Docker

El contenedor hello-world que se ejecutó en el paso anterior es un ejemplo de un contenedor que se ejecuta y se cierra tras emitir un mensaje de prueba. Los contenedores pueden ofrecer una utilidad mucho mayor y ser interactivos. Después de todo, son similares a las máquinas virtuales, aunque más flexibles con los recursos.

Como ejemplo, vamos a ejecutar un contenedor usando la imagen más reciente de NGINX.

`docker run nginx`{{exec}}

Como ejecutamos el comando docker sin modificadores, se inicio el container docker, pero no nos liberó la consola, para dejar el container corriendo en 2do plano, se debe agregar el modificador -d

`docker run -d -p 80:80 nginx`{{exec}}

#### Paso 6: Administrar contenedores de Docker

Después de usar Docker durante un tiempo, tendremos muchos contenedores activos (en ejecución) e inactivos en su computadora. Para ver los activos, utilizamos lo siguiente:

`docker ps`{{exec}}


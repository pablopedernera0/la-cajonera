### Instalando Docker en Ubuntu

Antes de levantar nuestro entorno de visualización, necesitamos tener Docker instalado. Seguí los pasos a continuación.

#### ACLARACION IMPORTANTE
Los Pasos 1 a 6 son opcionales en este entorno killercoda, este escenario ya tiene todo lo necesario para trabajar con docker.
Sin embargo, como en algunos entornos puede que no esté disponible, se incluye la guía de instalación como referencia.

#### Paso 1: Instalar dependencias previas (Opcional en esta práctica)

Instalamos los paquetes necesarios para que `apt` pueda trabajar con repositorios HTTPS:

`sudo apt-get update`{{exec}}

`sudo apt-get install -y ca-certificates curl`{{exec}}

#### Paso 2: Agregar la clave GPG oficial de Docker (Opcional en esta práctica)

`sudo install -m 0755 -d /etc/apt/keyrings`{{exec}}

`sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc`{{exec}}

`sudo chmod a+r /etc/apt/keyrings/docker.asc`{{exec}}

#### Paso 3: Agregar el repositorio de Docker a las fuentes de APT (Opcional en esta práctica)

`echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null`{{exec}}

`sudo apt-get update`{{exec}}

#### Paso 4: Instalar Docker Engine y Docker Compose (Opcional en esta práctica)

`sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`{{exec}}

#### Paso 5: Verificar la instalación (Opcional en esta práctica)

Comprobamos que Docker esté activo:

`sudo systemctl status docker`{{exec}}

El resultado debe mostrar que el servicio está **active (running)**.

#### Paso 6: Ejecutar Docker sin sudo (recomendado - Opcional en esta práctica)

Por defecto, el comando `docker` requiere permisos de root. Para evitar escribir `sudo` cada vez, agregamos nuestro usuario al grupo `docker`:

`sudo usermod -aG docker ${USER}`{{exec}}

`newgrp docker`{{exec}}

Verificamos que el usuario pertenece al grupo:

`id -nG`{{exec}}

Deberías ver `docker` en la lista de grupos.

#### Paso 7: Verificar Docker Compose

`docker compose version`{{exec}}

Si ves algo como `Docker Compose version v2.x.x`, estás listo para continuar.

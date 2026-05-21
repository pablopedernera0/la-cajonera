### Actualizando Docker Compose

Este entorno ya tiene Docker instalado y corriendo. Sin embargo, la versión disponible es `docker-compose` (con guion), que es la versión 1 — escrita en Python y hoy en día **deprecada**.

En este escenario vamos a usar `docker compose` (sin guion), que es el plugin oficial v2, integrado directamente en Docker. Vale la pena entender la diferencia antes de instalarlo.

#### docker-compose vs docker compose

| | `docker-compose` (v1) | `docker compose` (v2) |
|---|---|---|
| Instalación | Binario separado, en Python | Plugin integrado en Docker |
| Sintaxis | `docker-compose` | `docker compose` |
| Estado | **Deprecado** desde 2023 | **Estándar actual** |

> **Regla práctica:** Si encontrás tutoriales que usan `docker-compose` (con guion), reemplazalo por `docker compose` (sin guion). En la mayoría de los casos funciona exactamente igual.

#### Paso 1: Verificar lo que hay instalado

`docker-compose version`{{exec}}

`docker compose version`{{exec}}

El primero responde, el segundo falla. Eso es lo que vamos a corregir.

#### Paso 2: Instalar el plugin Docker Compose v2

`sudo apt-get update`{{exec}}

`sudo apt-get install -y docker-compose-plugin`{{exec}}

#### Paso 3: Verificar la instalación

`docker compose version`{{exec}}

Deberías ver algo como `Docker Compose version v2.x.x`. Ya podemos usar `docker compose` en todos los pasos siguientes.

#### Paso 4: Ejecutar Docker sin sudo

Por defecto el comando `docker` requiere permisos de root. Agregamos nuestro usuario al grupo `docker` para no tener que escribir `sudo` en cada comando:

`sudo usermod -aG docker ${USER}`{{exec}}

`newgrp docker`{{exec}}

Verificamos:

`id -nG`{{exec}}

Deberías ver `docker` en la lista. A partir de ahora usamos `docker` y `docker compose` directamente, sin `sudo`.
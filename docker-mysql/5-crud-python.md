#### Desplegando una aplicación CRUD con Python y Flask

Ahora que tenemos MySQL corriendo con nuestra base de datos `alumnos`, vamos a desplegar una aplicación web CRUD ya desarrollada. La idea es la misma que antes: solo ejecutamos comandos, nosotros no programamos nada.

#### Clonando el repositorio

`git clone https://github.com/pablopedernera0/crud-python.git`{{exec}}

`cd crud-python`{{exec}}

#### Instalando las dependencias de Python

`pip install flask mysql-connector-python --break-system-packages --ignore-installed`{{exec}}

#### Obteniendo la IP del container MySQL

La aplicación necesita conectarse al servidor MySQL que corre dentro de Docker. A diferencia de NGINX o PhpMyAdmin, MySQL no tiene su puerto expuesto al host, por lo que necesitamos usar su IP interna dentro de la red de Docker.

`MYSQL_IP=$(docker inspect $(docker ps --filter "ancestor=mysql:latest" -q) --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')`{{exec}}

`echo "IP del servidor MySQL: $MYSQL_IP"`{{exec}}

#### Configurando la conexión a la base de datos

Con la IP obtenida, actualizamos el archivo de configuración de la aplicación:

`sed -i "s/172.18.0.2/$MYSQL_IP/" app.py`{{exec}}

#### Iniciando la aplicación

`python app.py &`{{exec}}

Esperamos un momento y verificamos que levantó correctamente:

`sleep 2 && curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8888/`{{exec}}

Si el resultado es `200`, la aplicación está funcionando en el puerto **8888**.

Para acceder desde el navegador, hacemos click en el ícono hamburger arriba a la derecha, seleccionamos **"Traffic / Ports"**.

Buscamos la opción "Custom Ports" escribimos **8888** y le damos click al botón "Access".
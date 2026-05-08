#### Desplegando una aplicación CRUD con Python y Flask

Ahora que tenemos MySQL y PhpMyAdmin corriendo, vamos a desplegar una aplicación web CRUD que ya está desarrollada. La idea es la misma que antes: solo ejecutamos comandos, nosotros no programamos nada.

#### Clonando el repositorio

`git clone https://github.com/urian121/CRUD-COMPLETO-con-Python-MySQL-y-un-Dashboard.git crud-app`{{exec}}

`cd crud-app/my-app`{{exec}}

#### Creando el archivo de configuración

La aplicación necesita saber cómo conectarse a la base de datos MySQL que ya está corriendo en Docker. Para eso vamos a generar el archivo de configuración usando el siguiente comando:

`cat > conexionBD.py << 'EOF'
import mysql.connector

def get_connection():
    return mysql.connector.connect(
        host="127.0.0.1",
        port=3306,
        user="root",
        password="mysecretpassword",
        database="crud_python"
    )
EOF`{{exec}}

#### Precargando la base de datos

La aplicación necesita su propia base de datos con tablas y datos de ejemplo. Vamos a importarla directamente al servidor MySQL que ya está corriendo en Docker.

Primero copiamos el archivo SQL al container:

`docker cp ../crud_python.sql $(docker ps --filter "ancestor=mysql:latest" -q):/crud_python.sql`{{exec}}

Ahora lo importamos:

`docker exec -i $(docker ps --filter "ancestor=mysql:latest" -q) mysql -u root -pmysecretpassword -e "source /crud_python.sql;"`{{exec}}

Verificamos que la base de datos fue creada correctamente:

`docker exec -i $(docker ps --filter "ancestor=mysql:latest" -q) mysql -u root -pmysecretpassword -e "SHOW DATABASES;"`{{exec}}

#### Instalando las dependencias de Python

`pip install -r ../requirements.txt --break-system-packages`{{exec}}

#### Iniciando la aplicación

`python app.py &`{{exec}}

La aplicación queda corriendo en segundo plano en el puerto **5600**.

Podemos verificar que está escuchando con:

`curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:5600/`{{exec}}

Si el resultado es `200`, la aplicación está funcionando correctamente.

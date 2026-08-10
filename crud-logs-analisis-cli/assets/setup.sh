#!/bin/bash
# =============================================================================
#  setup.sh — crud-logs-analisis-cli
#  Prepara el entorno Y genera tráfico realista (uso normal, stress test,
#  fuerza bruta e inyección SQL) para que haya evidencia real que analizar.
#  Se ejecuta una sola vez al inicio del escenario
# =============================================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

banner() { echo -e "\n${CYAN}[$1]${NC} $2"; }
ok()     { echo -e "${GREEN}  ✓${NC} $1"; }
warn()   { echo -e "${YELLOW}  ⚠${NC} $1"; }

echo ""
echo "=============================================="
echo "  Preparando entorno — crud-logs-analisis-cli"
echo "=============================================="

# ── 1. Dependencias del sistema ────────────────────────────────────────────
banner "1/6" "Instalando dependencias del sistema..."
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    docker-compose \
    python3-pip \
    git
ok "Dependencias del sistema instaladas"

# ── 2. Dependencias Python ─────────────────────────────────────────────────
banner "2/6" "Instalando dependencias Python..."
pip3 install flask mysql-connector-python \
    --break-system-packages --ignore-installed --quiet
ok "flask y mysql-connector-python instalados"

# ── 3. Levantar MySQL + PhpMyAdmin + Nginx con Docker Compose ──────────────
banner "3/6" "Levantando servicios con Docker Compose..."

mkdir -p /root/crud-logs-analisis-cli

cat > /root/crud-logs-analisis-cli/docker-compose.yml << 'EOF'
version: '3'
services:

  mysql:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysecretpassword
    networks:
      - mynetwork

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    restart: always
    ports:
      - 8080:80
    environment:
      PMA_HOST: mysql
      PMA_USER: root
      PMA_PASSWORD: mysecretpassword
    depends_on:
      - mysql
    networks:
      - mynetwork

  web:
    image: nginx
    ports:
      - "80:80"
    networks:
      - mynetwork

networks:
  mynetwork:
EOF

cd /root/crud-logs-analisis-cli
docker-compose up -d
ok "Contenedores iniciados"

# ── 4. Esperar MySQL, crear tablas y habilitar el general query log ───────
banner "4/6" "Esperando MySQL, creando tablas y habilitando el general_log..."

echo -n "  Esperando MySQL"
MYSQL_READY=0
for i in $(seq 1 30); do
    if docker exec "$(docker ps -qf "name=mysql")" \
        mysqladmin ping -h 127.0.0.1 -uroot -pmysecretpassword --silent 2>/dev/null; then
        echo ""
        ok "MySQL listo"
        MYSQL_READY=1
        break
    fi
    echo -n "."
    sleep 2
done

if [ "$MYSQL_READY" -eq 0 ]; then
    warn "MySQL tardó demasiado. Reintentando en 10 segundos..."
    sleep 10
fi

docker exec -i "$(docker ps -qf "name=mysql")" \
    mysql -h 127.0.0.1 -uroot -pmysecretpassword << 'EOSQL'
CREATE DATABASE IF NOT EXISTS alumnos;
USE alumnos;

CREATE TABLE IF NOT EXISTS alumnos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL
);
INSERT INTO alumnos (nombre, apellido, fecha_nacimiento) VALUES
  ('Juan', 'Perez', '2000-01-01'),
  ('Maria', 'Gomez', '1999-05-15'),
  ('Pedro', 'Lopez', '2001-10-20'),
  ('Ana', 'Martinez', '1998-03-08'),
  ('Luis', 'Rodriguez', '2002-07-12');

CREATE TABLE IF NOT EXISTS usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  usuario VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(50) NOT NULL
);
INSERT INTO usuarios (usuario, password) VALUES
  ('admin', 'admin123');
EOSQL
ok "Base 'alumnos' con datos semilla y tabla 'usuarios' creadas"

docker exec "$(docker ps -qf "name=mysql")" \
    mysql -h 127.0.0.1 -uroot -pmysecretpassword -e "
SET GLOBAL general_log_file = '/var/lib/mysql/general.log';
SET GLOBAL log_output = 'FILE';
SET GLOBAL general_log = 'ON';
"
ok "general_log habilitado (queda registrando cada consulta a partir de ahora)"

# ── 5. Clonar el CRUD (branch feature-login) y levantarlo ─────────────────
banner "5/6" "Clonando la app Flask (con login) y conectándola a MySQL..."

MYSQL_IP=$(docker inspect \
    "$(docker ps -qf "name=mysql")" \
    --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

cd /root
git clone --branch feature-login https://github.com/pablopedernera0/crud-python.git 2>/dev/null || true
sed -i "s/172.18.0.2/$MYSQL_IP/" /root/crud-python/app.py

cd /root/crud-python
nohup python3 app.py > /root/crud-python/app.log 2>&1 &

echo -n "  Esperando la app Flask"
for i in $(seq 1 20); do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8888/login 2>/dev/null || echo "000")
    if [ "$CODE" = "200" ]; then
        echo ""
        ok "App Flask lista en el puerto 8888"
        break
    fi
    echo -n "."
    sleep 2
done

# ── 6. Generar tráfico: uso normal, stress test, fuerza bruta e inyección ──
banner "6/6" "Generando tráfico de referencia (esto va a ser lo que investiguemos)..."

# Uso normal
curl -s -o /dev/null http://127.0.0.1:8888/login
sleep 1
curl -s -c /root/normal-cookies.txt -o /dev/null \
    --data-urlencode "usuario=admin" --data-urlencode "password=admin123" \
    http://127.0.0.1:8888/login
sleep 1
curl -s -b /root/normal-cookies.txt -o /dev/null http://127.0.0.1:8888/
sleep 2

# Pico de carga (imita el stress test de la práctica 1)
for i in $(seq 1 60); do
    curl -s -o /dev/null http://127.0.0.1:8888/ &
done
wait
sleep 1

# Fuerza bruta (imita la práctica 3)
for pass in 123456 password qwerty letmein alumnos2024 rootroot 111111 hunter2 changeme; do
    curl -s -o /dev/null --data-urlencode "usuario=admin" --data-urlencode "password=$pass" \
        http://127.0.0.1:8888/login
done
curl -s -o /dev/null --data-urlencode "usuario=admin" --data-urlencode "password=admin123" \
    http://127.0.0.1:8888/login
sleep 1

# Inyección SQL: un intento fallido de control y dos bypass exitosos (práctica 4)
curl -s -o /dev/null --data-urlencode "usuario=admin' AND '1'='2" --data-urlencode "password=x" \
    http://127.0.0.1:8888/login
curl -s -o /dev/null --data-urlencode "usuario=admin' -- " --data-urlencode "password=x" \
    http://127.0.0.1:8888/login
curl -s -o /dev/null --data-urlencode "usuario=' OR '1'='1' -- " --data-urlencode "password=x" \
    http://127.0.0.1:8888/login

ok "Tráfico generado"

# ── Resumen ──────────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo. Podés continuar con el Paso 1.${NC}"
echo "=============================================="
echo ""
echo "  Servicios corriendo:"
echo "    MySQL       → red interna Docker (general_log habilitado)"
echo "    PhpMyAdmin  → puerto 8080"
echo "    Nginx       → puerto 80"
echo "    CRUD Flask  → puerto 8888"
echo ""
echo "  Ya hay tráfico real en los logs para investigar:"
echo "    /root/crud-python/app.log         → logs de acceso de la app"
echo "    /var/lib/mysql/general.log (en el contenedor mysql) → cada consulta SQL ejecutada"
echo ""
echo "  Próximo paso: encontrar el pico de carga en los logs de la app."
echo "=============================================="
echo ""

#!/bin/bash
# =============================================================================
#  setup.sh — crud-sistema-operativo
#  Prepara el entorno para la práctica de sistemas operativos
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
echo "  Preparando entorno — crud-sistema-operativo"
echo "=============================================="

# ── 1. Dependencias del sistema ────────────────────────────────────────────
banner "1/7" "Instalando dependencias del sistema..."
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    docker-compose \
    python3-pip \
    git \
    strace \
    psmisc
ok "Dependencias instaladas (strace para ver syscalls, psmisc trae pstree)"

# ── 2. Dependencias Python ─────────────────────────────────────────────────
banner "2/7" "Instalando dependencias Python..."
pip3 install flask mysql-connector-python gunicorn \
    --break-system-packages --ignore-installed --quiet
ok "flask, mysql-connector-python y gunicorn instalados"

# ── 3. Levantar MySQL + cAdvisor + Prometheus ──────────────────────────────
banner "3/7" "Levantando MySQL, cAdvisor y Prometheus..."

mkdir -p /root/so
cd /root/so

cat > prometheus.yml << 'EOF'
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
EOF

cat > docker-compose.yml << 'EOF'
version: '3'
services:

  mysql:
    image: mysql:latest
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: mysecretpassword
    networks:
      - mynetwork

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.47.2
    container_name: cadvisor
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    networks:
      - mynetwork

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    networks:
      - mynetwork

networks:
  mynetwork:
EOF

docker-compose up -d
ok "Contenedores iniciados"

# ── 4. Esperar MySQL y crear las tablas ────────────────────────────────────
banner "4/7" "Esperando MySQL y creando la base de datos..."

echo -n "  Esperando MySQL"
MYSQL_READY=0
for i in $(seq 1 30); do
    if docker exec mysql \
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

docker exec -i mysql \
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
EOSQL
ok "Base 'alumnos' con datos semilla creada"

# ── 5. Clonar el CRUD y levantarlo con Gunicorn (2 workers) ────────────────
banner "5/7" "Clonando la app Flask y levantándola con Gunicorn..."

MYSQL_IP=$(docker inspect mysql \
    --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

cd /root
git clone https://github.com/pablopedernera0/crud-python.git 2>/dev/null || true
sed -i "s/172.18.0.2/$MYSQL_IP/" /root/crud-python/app.py

cd /root/crud-python
nohup gunicorn -w 2 -b 0.0.0.0:8888 app:app > /root/crud-python/gunicorn.log 2>&1 &

echo -n "  Esperando la app"
for i in $(seq 1 20); do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8888/ 2>/dev/null || echo "000")
    if [ "$CODE" = "200" ]; then
        echo ""
        ok "App lista en el puerto 8888 (Gunicorn: 1 master + 2 workers)"
        break
    fi
    echo -n "."
    sleep 2
done

# ── 6. Esperar a Prometheus ────────────────────────────────────────────────
banner "6/7" "Esperando a Prometheus..."

echo -n "  Esperando Prometheus"
for i in $(seq 1 30); do
    if curl -s http://localhost:9090/-/ready > /dev/null 2>&1; then
        echo ""
        ok "Prometheus listo"
        break
    fi
    echo -n "."
    sleep 2
done

# ── 7. Dejar los scripts de la práctica accesibles como comandos ───────────
banner "7/7" "Instalando los scripts de la práctica..."
for s in carga_http.sh abrir_conexiones.sh ver_cgroup.sh probar_oom.sh \
         carga_cpu_mysql.sh consulta_cpu_mysql.sh; do
    cp "/root/$s" "/usr/local/bin/$s"
    chmod +x "/usr/local/bin/$s"
done
# Imagen chica para la prueba de memoria del Paso 4: bajarla ahora evita la espera después
docker pull -q alpine:latest > /dev/null
ok "Scripts disponibles como comandos"

# ── Resumen ──────────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo. Podés continuar con el Paso 1.${NC}"
echo "=============================================="
echo ""
echo "  Servicios corriendo:"
echo "    MySQL        → contenedor 'mysql' (red interna Docker)"
echo "    cAdvisor     → métricas de contenedores para Prometheus"
echo "    Prometheus   → puerto 9090"
echo "    CRUD Flask   → puerto 8888, servida por Gunicorn (1 master + 2 workers)"
echo ""
echo "  Scripts de la práctica:"
echo "    carga_http.sh          → genera tráfico HTTP contra la app"
echo "    abrir_conexiones.sh    → abre conexiones simultáneas a MySQL"
echo "    ver_cgroup.sh          → muestra lo que el kernel cuenta de un contenedor"
echo "    probar_oom.sh          → contenedor que se queda sin memoria a propósito"
echo "    carga_cpu_mysql.sh     → trabajo de CPU acotado dentro de MySQL"
echo "    consulta_cpu_mysql.sh  → consulta PromQL lista para pegar"
echo ""
echo "  Próximo paso: conocer el kernel sobre el que corre todo esto."
echo "=============================================="
echo ""

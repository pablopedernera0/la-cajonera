#!/bin/bash
# =============================================================================
#  setup.sh — crud-monitoreo-prometheus-grafana
#  Prepara el entorno para la práctica de monitoreo en vivo
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
echo "  Preparando entorno — crud-monitoreo-prometheus-grafana"
echo "=============================================="

# ── 1. Dependencias del sistema ────────────────────────────────────────────
banner "1/6" "Instalando dependencias del sistema..."
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    docker-compose \
    python3-pip \
    git
ok "Dependencias del sistema instaladas (curl y xargs ya vienen en la imagen base)"

# ── 2. Dependencias Python ─────────────────────────────────────────────────
banner "2/6" "Instalando dependencias Python..."
pip3 install flask mysql-connector-python prometheus-flask-exporter \
    --break-system-packages --ignore-installed --quiet
ok "flask, mysql-connector-python y prometheus-flask-exporter instalados"

# ── 3. Levantar MySQL + stack de monitoreo con Docker Compose ─────────────
banner "3/6" "Levantando MySQL, cAdvisor, mysqld-exporter, Prometheus y Grafana..."

mkdir -p /root/monitoreo
cd /root/monitoreo

cat > my.cnf << 'EOF'
[client]
user=root
password=mysecretpassword
host=mysql
port=3306
EOF

cat > prometheus.yml << 'EOF'
global:
  scrape_interval: 5s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  - job_name: 'mysql'
    static_configs:
      - targets: ['dbexporter:9104']

  - job_name: 'crud-app'
    static_configs:
      - targets: ['host.docker.internal:8888']
EOF

cat > docker-compose.yml << 'EOF'
version: '3'
services:

  mysql:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysecretpassword
    networks:
      - mynetwork

  dbexporter:
    image: prom/mysqld-exporter:latest
    restart: always
    volumes:
      - ./my.cnf:/.my.cnf:ro
    command:
      - --config.my-cnf=/.my.cnf
    depends_on:
      - mysql
    networks:
      - mynetwork

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.47.2
    restart: always
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
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    extra_hosts:
      - "host.docker.internal:host-gateway"
    networks:
      - mynetwork

  grafana:
    image: grafana/grafana:latest
    restart: always
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus
    networks:
      - mynetwork

networks:
  mynetwork:
EOF

docker-compose up -d
ok "Contenedores iniciados"

# ── 4. Esperar MySQL y crear las tablas ────────────────────────────────────
banner "4/6" "Esperando MySQL y creando la base de datos..."

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
EOSQL
ok "Base 'alumnos' con datos semilla creada"

# ── 5. Clonar el CRUD (branch monitoring) y levantarlo ─────────────────────
banner "5/6" "Clonando la app Flask instrumentada y conectándola a MySQL..."

MYSQL_IP=$(docker inspect \
    "$(docker ps -qf "name=mysql")" \
    --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

cd /root
git clone --branch monitoring https://github.com/pablopedernera0/crud-python.git 2>/dev/null || true
sed -i "s/172.18.0.2/$MYSQL_IP/" /root/crud-python/app.py

cd /root/crud-python
nohup python3 app.py > /root/crud-python/app.log 2>&1 &

echo -n "  Esperando la app Flask"
for i in $(seq 1 20); do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8888/ 2>/dev/null || echo "000")
    if [ "$CODE" = "200" ]; then
        echo ""
        ok "App Flask lista en el puerto 8888 (métricas en /metrics)"
        break
    fi
    echo -n "."
    sleep 2
done

# ── 6. Esperar a que Prometheus tenga todos los targets arriba ────────────
banner "6/6" "Esperando a que Prometheus levante todos los targets..."

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

# ── Resumen ──────────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo. Podés continuar con el Paso 1.${NC}"
echo "=============================================="
echo ""
echo "  Servicios corriendo:"
echo "    MySQL        → red interna Docker"
echo "    dbexporter   → métricas de MySQL para Prometheus"
echo "    cAdvisor     → métricas de contenedores para Prometheus"
echo "    Prometheus   → puerto 9090"
echo "    Grafana      → puerto 3000 (usuario: admin / password: admin)"
echo "    CRUD Flask   → puerto 8888 (métricas en /metrics)"
echo ""
echo "  Próximo paso: entender qué es una métrica y cómo la junta Prometheus."
echo "=============================================="
echo ""

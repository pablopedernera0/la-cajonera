#!/bin/bash
# =============================================================================
#  setup.sh — cloud-storage-101
#  Prepara el entorno para la práctica de AWS S3 con Floci
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
echo "  Preparando entorno — cloud-storage-101"
echo "=============================================="

# ── 1. Dependencias del sistema ───────────────────────────────────────────────
banner "1/5" "Instalando dependencias del sistema..."
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    docker-compose \
    python3-pip \
    git
ok "Dependencias del sistema instaladas"

# ── 2. Dependencias Python (incluyendo awscli) ────────────────────────────────
banner "2/5" "Instalando dependencias Python..."
pip3 install flask mysql-connector-python boto3 python-dotenv awscli \
        --break-system-packages --ignore-installed --quiet
ok "flask, mysql-connector-python, boto3, python-dotenv, awscli instalados"

# ── 3. Levantar MySQL + Floci + floci-panel con Docker Compose ────────────────
banner "3/5" "Levantando servicios con Docker Compose..."

mkdir -p /root/cloud-storage-101

cat > /root/cloud-storage-101/docker-compose.yml << 'EOF'
version: '3'
services:

  mysql:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mysecretpassword
      MYSQL_DATABASE: alumnos
    networks:
      - redpractica

  floci:
    image: hectorvent/floci:latest
    restart: always
    ports:
      - "4566:4566"
    environment:
      - FLOCI_STORAGE_MODE=memory
      - FLOCI_DEFAULT_REGION=us-east-1
      - FLOCI_HOSTNAME=floci
    networks:
      - redpractica

  floci-panel:
    image: ghcr.io/pablopedernera0/floci-panel:latest
    restart: always
    ports:
      - "4580:80"
    environment:
      - FLOCI_ENDPOINT=http://floci:4566
      - FLOCI_REGION=us-east-1
      - FLOCI_ACCESS_KEY=test
      - FLOCI_SECRET_KEY=test
    depends_on:
      - floci
    networks:
      - redpractica

networks:
  redpractica:
EOF

cd /root/cloud-storage-101
docker-compose up -d
ok "Contenedores iniciados"

# ── 4. Esperar que los servicios estén listos ─────────────────────────────────
banner "4/5" "Esperando que los servicios estén listos..."

# Esperar MySQL — hasta 60 segundos
echo -n "  Esperando MySQL"
MYSQL_READY=0
for i in $(seq 1 30); do
    if docker exec $(docker ps -qf "name=mysql") \
        mysqladmin ping -uroot -pmysecretpassword --silent 2>/dev/null; then
        echo ""
        ok "MySQL listo"
        MYSQL_READY=1
        break
    fi
    echo -n "."
    sleep 2
done

if [ $MYSQL_READY -eq 0 ]; then
    warn "MySQL tardó demasiado. Reintentando en 10 segundos..."
    sleep 10
fi

# Crear tabla alumnos con columna foto_url
docker exec $(docker ps -qf "name=mysql") \
    mysql -uroot -pmysecretpassword alumnos << 'EOSQL'
CREATE TABLE IF NOT EXISTS alumnos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  foto_url VARCHAR(500)
);
EOSQL
ok "Tabla 'alumnos' creada"

# Obtener IP de MySQL para el .env
MYSQL_IP=$(docker inspect \
    $(docker ps -qf "name=mysql") \
    --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

# Esperar Floci — hasta 40 segundos
echo -n "  Esperando Floci"
for i in $(seq 1 20); do
    if curl -s http://localhost:4566 > /dev/null 2>&1; then
        echo ""
        ok "Floci listo"
        break
    fi
    echo -n "."
    sleep 2
done

# ── 5. Crear bucket y clonar proyecto ────────────────────────────────────────
banner "5/5" "Configurando S3 y clonando el proyecto..."

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

aws s3 mb s3://fotos-alumnos
ok "Bucket 'fotos-alumnos' creado"

cd /root
git clone --branch aws-s3-floci \
    https://github.com/pablopedernera0/crud-python.git \
    crud-python 2>/dev/null || true
ok "Proyecto clonado en /root/crud-python"

# Obtener URL pública de Floci desde KillerCoda
KILLERCODA_HOST=$(cat /etc/killercoda/host 2>/dev/null || echo "http://localhost:4566")
S3_PUBLIC_URL=${KILLERCODA_HOST/PORT/4566}

# Generar .env con IP real de MySQL y URL pública de Floci
cat > /root/crud-python/.env << ENVEOF
# ── MySQL ──────────────────────────────────────────────────────────────────
MYSQL_HOST=${MYSQL_IP}
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=mysecretpassword
MYSQL_DATABASE=alumnos

# ── S3 / Floci ─────────────────────────────────────────────────────────────
S3_ENDPOINT=http://localhost:4566
S3_PUBLIC_URL=${S3_PUBLIC_URL}
S3_REGION=us-east-1
S3_BUCKET=fotos-alumnos

# Completar con las keys que vas a generar en el Paso 2
AWS_ACCESS_KEY_ID=REEMPLAZAR
AWS_SECRET_ACCESS_KEY=REEMPLAZAR
ENVEOF
ok "Archivo .env generado en /root/crud-python/.env"

# ── Resumen ───────────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo. Podés continuar con el Paso 1.${NC}"
echo "=============================================="
echo ""
echo "  Servicios corriendo:"
echo "    MySQL       → red interna Docker"
echo "    Floci       → http://localhost:4566"
echo "    Floci Panel → http://localhost:4580"
echo ""
echo "  Bucket creado:  s3://fotos-alumnos"
echo "  CRUD clonado:   /root/crud-python"
echo ""
echo "  Próximo paso: verificar el entorno en el Paso 1."
echo "=============================================="
echo ""
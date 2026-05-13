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
NC='\033[0m' # sin color

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
    awscli \
    python3-pip \
    git
ok "Dependencias instaladas"

# ── 2. Dependencias Python ────────────────────────────────────────────────────
banner "2/5" "Instalando dependencias Python..."
pip install flask mysql-connector-python boto3 python-dotenv \
    --break-system-packages --quiet
ok "Flask, boto3 y python-dotenv instalados"

# ── 3. Levantar MySQL + Floci con Docker Compose ──────────────────────────────
banner "3/5" "Levantando MySQL y Floci..."

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

# Esperar MySQL
echo -n "  Esperando MySQL"
for i in $(seq 1 30); do
    if docker exec $(docker ps -qf "ancestor=mysql:latest") \
        mysqladmin ping -uroot -pmysecretpassword --silent 2>/dev/null; then
        echo ""
        ok "MySQL listo"
        break
    fi
    echo -n "."
    sleep 2
done

# Crear tabla con columna foto_url
MYSQL_IP=$(docker inspect \
    $(docker ps -qf "ancestor=mysql:latest") \
    --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

docker exec $(docker ps -qf "ancestor=mysql:latest") \
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

# Esperar Floci
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

# ── 5. Crear bucket S3 ────────────────────────────────────────────────────────
banner "5/5" "Creando bucket S3..."

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

aws s3 mb s3://fotos-alumnos
ok "Bucket 'fotos-alumnos' creado"

# ── Clonar el CRUD ────────────────────────────────────────────────────────────
banner "+" "Clonando el proyecto CRUD..."
cd /root
git clone --branch aws-s3-floci \
    https://github.com/pablopedernera0/crud-python.git \
    crud-python 2>/dev/null || true

# Generar .env con la IP real de MySQL (el alumno completará las keys)
cat > /root/crud-python/.env << ENVEOF
# ── MySQL ──────────────────────────────────────────────────────────────────
MYSQL_HOST=${MYSQL_IP}
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=mysecretpassword
MYSQL_DATABASE=alumnos

# ── S3 / Floci ─────────────────────────────────────────────────────────────
S3_ENDPOINT=http://localhost:4566
S3_REGION=us-east-1
S3_BUCKET=fotos-alumnos

# Completar con las keys que vas a generar en el Paso 2
AWS_ACCESS_KEY_ID=REEMPLAZAR
AWS_SECRET_ACCESS_KEY=REEMPLAZAR
ENVEOF
ok "Archivo .env generado en /root/crud-python/.env"

# ── Resumen final ─────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo. Podés continuar con el Paso 1.${NC}"
echo "=============================================="
echo ""
echo "  Servicios corriendo:"
echo "    MySQL  → interno en la red Docker"
echo "    Floci  → http://localhost:4566"
echo ""
echo "  Bucket creado: s3://fotos-alumnos"
echo "  CRUD clonado:  /root/crud-python"
echo ""
echo "  Próximo paso: crear tu usuario IAM y obtener las API Keys."
echo "=============================================="
echo ""

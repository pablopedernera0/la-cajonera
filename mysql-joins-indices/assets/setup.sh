#!/bin/bash
# =============================================================================
#  setup.sh — mysql-joins-indices
#  Levanta MySQL + phpMyAdmin y carga los datos de la práctica:
#    - tienda: clientes, productos, pedidos (tablas chicas, para JOINs)
#    - padron: 3 millones de personas inventadas, sin índices (para medir)
#  Se ejecuta una sola vez al inicio del escenario
# =============================================================================

set -e

# Cantidad de filas del padrón. Calibrado para que una búsqueda sin índice
# tarde un par de segundos y un lote de 10 logins supere los 10 segundos.
FILAS=${FILAS:-3000000}

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

banner() { echo -e "\n${CYAN}[$1]${NC} $2"; }
ok()     { echo -e "${GREEN}  ✓${NC} $1"; }
warn()   { echo -e "${YELLOW}  ⚠${NC} $1"; }
error()  { echo -e "${RED}  ✗${NC} $1"; }

echo ""
echo "=============================================="
echo "  Preparando entorno — mysql-joins-indices"
echo "=============================================="

# ── 1. docker-compose ──────────────────────────────────────────────────────
banner "1/5" "Verificando docker-compose..."
if docker compose version >/dev/null 2>&1; then
    COMPOSE="docker compose"
    ok "Docker Compose ya está disponible (plugin de docker)"
elif command -v docker-compose >/dev/null 2>&1; then
    COMPOSE="docker-compose"
    ok "docker-compose ya está instalado"
else
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-compose
    COMPOSE="docker-compose"
    ok "docker-compose instalado"
fi

# ── 2. Levantar MySQL + phpMyAdmin ─────────────────────────────────────────
banner "2/5" "Levantando MySQL y phpMyAdmin..."

mkdir -p /root/mysql-joins-indices

# Versiones fijas: la guía describe pantallas de phpMyAdmin 5.2.2.
# innodb-buffer-pool-size explícito: con 128 MB el padrón (~330 MB) no entra
# en memoria, y eso es lo que hace visible la diferencia sin/con índice.
cat > /root/mysql-joins-indices/docker-compose.yml << 'EOF'
services:

  mysql:
    image: mysql:8.4
    container_name: mysql
    restart: always
    command: --innodb-buffer-pool-size=128M
    environment:
      MYSQL_ROOT_PASSWORD: mysecretpassword
    networks:
      - practica

  phpmyadmin:
    image: phpmyadmin:5.2.2
    container_name: phpmyadmin
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
      - practica

networks:
  practica:
EOF

cd /root/mysql-joins-indices
$COMPOSE up -d
ok "Contenedores iniciados"

# ── 3. Esperar MySQL ───────────────────────────────────────────────────────
banner "3/5" "Esperando que MySQL esté listo..."

# Ping por TCP (-h 127.0.0.1), no por socket: al arrancar, la imagen de MySQL
# levanta un servidor temporal solo por socket, responde el ping y se reinicia.
echo -n "  Esperando MySQL"
MYSQL_READY=0
for i in $(seq 1 60); do
    if docker exec mysql mysqladmin ping -h 127.0.0.1 -uroot -pmysecretpassword --silent >/dev/null 2>&1; then
        echo ""
        ok "MySQL listo"
        MYSQL_READY=1
        break
    fi
    echo -n "."
    sleep 2
done

if [ "$MYSQL_READY" -eq 0 ]; then
    echo ""
    error "MySQL no respondió en 2 minutos. Revisá con: docker logs mysql"
    exit 1
fi

# ── 4. Cargar los datos ────────────────────────────────────────────────────
banner "4/5" "Cargando datos..."

docker exec -i mysql mysql --default-character-set=utf8mb4 -h 127.0.0.1 -uroot -pmysecretpassword < /root/tienda.sql 2>/dev/null
ok "Tablas chicas creadas: clientes, productos, pedidos"

echo "  Generando el padrón ($FILAS personas inventadas, tarda uno o dos minutos)..."
INICIO=$(date +%s)
( echo "SET @filas = $FILAS;"; cat /root/padron.sql ) \
    | docker exec -i mysql mysql --default-character-set=utf8mb4 -h 127.0.0.1 -uroot -pmysecretpassword >/dev/null 2>&1
ok "Tablas grandes creadas: localidades, padron ($(( $(date +%s) - INICIO )) segundos)"

CARGADAS=$(docker exec mysql mysql --default-character-set=utf8mb4 -h 127.0.0.1 -uroot -pmysecretpassword -N practica \
    -e "SELECT COUNT(*) FROM padron" 2>/dev/null)
if [ "$CARGADAS" != "$FILAS" ]; then
    error "El padrón tiene $CARGADAS filas y debería tener $FILAS"
    exit 1
fi

# ── 5. Medición de referencia ──────────────────────────────────────────────
banner "5/5" "Midiendo una búsqueda sin índice (referencia)..."
INICIO=$(date +%s.%N)
docker exec mysql mysql --default-character-set=utf8mb4 -h 127.0.0.1 -uroot -pmysecretpassword -N practica \
    -e "SELECT id FROM padron WHERE email = 'persona1500007@correo.com.ar'" >/dev/null 2>&1
FIN=$(date +%s.%N)
ok "$(awk -v i="$INICIO" -v f="$FIN" 'BEGIN { printf "Una búsqueda por email tarda %.2f segundos en esta máquina", f - i }')"

echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo${NC}"
echo "=============================================="
echo "  MySQL       contenedor 'mysql' (usuario root / mysecretpassword)"
echo "  phpMyAdmin  puerto 8080"
echo "  Base        practica"
echo "              clientes, productos, pedidos  (chicas)"
echo "              localidades, padron           ($CARGADAS filas, sin índices)"
echo ""
echo "  Consola SQL: docker exec -it mysql mysql --default-character-set=utf8mb4 -uroot -pmysecretpassword practica"
echo ""

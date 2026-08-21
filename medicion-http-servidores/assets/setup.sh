#!/bin/bash
# =============================================================================
#  setup.sh — medicion-http-servidores
#  Verifica que el entorno esté listo para medir tiempos de respuesta y
#  tamaño de páginas/APIs públicas con curl.
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
echo "  Preparando entorno — medicion-http-servidores"
echo "=============================================="

# ── 1. curl ─────────────────────────────────────────────────────────────────
banner "1/3" "Verificando curl..."
if ! command -v curl &> /dev/null; then
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq curl
fi
ok "curl disponible: $(curl --version | head -n1)"

# ── 2. Salida a internet ────────────────────────────────────────────────────
banner "2/3" "Verificando salida a internet..."
CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 8 https://es.wikipedia.org/wiki/HTTP || echo "000")
if [ "$CODE" = "200" ]; then
    ok "Conectividad a internet confirmada"
else
    warn "No se pudo confirmar la salida a internet (código: $CODE). Avisale a tu docente."
fi

# ── 3. Dejar el script de métricas accesible como comando ──────────────────
banner "3/3" "Dejando obtener-metricas.sh accesible como comando..."
cp /root/obtener-metricas.sh /usr/local/bin/obtener-metricas.sh
chmod +x /usr/local/bin/obtener-metricas.sh
ok "obtener-metricas.sh disponible como comando"

echo ""
echo "=============================================="
echo "  Entorno listo"
echo "=============================================="
echo ""
echo "  Script disponible: obtener-metricas.sh <url>"
echo ""
echo "  Ejemplo:"
echo "    obtener-metricas.sh https://es.wikipedia.org/wiki/HTTP"
echo ""
echo "=============================================="
echo ""

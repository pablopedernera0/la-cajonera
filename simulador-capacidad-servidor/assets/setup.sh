#!/bin/bash
# =============================================================================
#  setup.sh — simulador-capacidad-servidor
#  Levanta el servidor simulado y deja los scripts de carga/upgrade
#  disponibles como comandos.
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
echo "  Preparando entorno — simulador-capacidad-servidor"
echo "=============================================="

# ── 1. Verificar python3 y curl ─────────────────────────────────────────────
banner "1/3" "Verificando python3 y curl..."
if ! command -v python3 &> /dev/null || ! command -v curl &> /dev/null; then
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3 curl
fi
ok "python3 y curl disponibles"

# ── 2. Levantar el servidor simulado ───────────────────────────────────────
banner "2/3" "Levantando el servidor simulado en el puerto 8080..."
cd /root
nohup python3 servidor.py > /root/servidor.log 2>&1 &

echo -n "  Esperando el servidor"
LISTO=0
for i in $(seq 1 15); do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/status 2>/dev/null || echo "000")
    if [ "$CODE" = "200" ]; then
        echo ""
        ok "Servidor simulado listo en el puerto 8080"
        LISTO=1
        break
    fi
    echo -n "."
    sleep 1
done
if [ "$LISTO" -eq 0 ]; then
    warn "El servidor tardó más de lo esperado. Revisá /root/servidor.log"
fi

# ── 3. Scripts disponibles como comandos ───────────────────────────────────
banner "3/3" "Dejando los scripts disponibles como comandos..."
for script in subir_carga.sh sumar_cpu.sh sumar_ram.sh; do
    cp "/root/$script" "/usr/local/bin/$script"
    chmod +x "/usr/local/bin/$script"
done
ok "subir_carga.sh, sumar_cpu.sh y sumar_ram.sh disponibles como comandos"

echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo. Podés continuar con el Paso 1.${NC}"
echo "=============================================="
echo ""
echo "  Servidor simulado → puerto 8080 (ver pestaña de tráfico o /status)"
echo "  Comandos disponibles: subir_carga.sh · sumar_cpu.sh · sumar_ram.sh"
echo "=============================================="
echo ""

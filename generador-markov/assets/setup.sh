#!/bin/bash
# =============================================================================
#  setup.sh — generador-markov
#  Clona el generador de Markov en Python e instala markovify
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

REPO=https://github.com/pablopedernera0/generador-markov-python.git
DIR=/root/generador-markov-python

echo ""
echo "=============================================="
echo "  Preparando entorno — generador-markov"
echo "=============================================="

# ── 1. Dependencias del sistema ────────────────────────────────────────────
banner "1/3" "Instalando dependencias del sistema..."
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-pip git > /dev/null
ok "python3 $(python3 -c 'import platform; print(platform.python_version())'), pip y git instalados"

# ── 2. Código ──────────────────────────────────────────────────────────────
banner "2/3" "Clonando el generador..."
if [ -d "$DIR/.git" ]; then
    git -C "$DIR" pull -q
    warn "Ya estaba clonado: se actualizó"
else
    git clone -q "$REPO" "$DIR"
    ok "Código en $DIR"
fi

# ── 3. markovify ───────────────────────────────────────────────────────────
banner "3/3" "Instalando markovify..."
pip3 install markovify --break-system-packages --quiet --root-user-action=ignore
ok "markovify $(python3 -c 'import importlib.metadata as m; print(m.version("markovify"))') instalado"

echo ""
echo "=============================================="
echo -e "  ${GREEN}Entorno listo${NC}"
echo "=============================================="
echo "  Carpeta:  $DIR"
echo "  Probar:   cd $DIR && python3 markov.py textos/hechos.txt"
echo ""

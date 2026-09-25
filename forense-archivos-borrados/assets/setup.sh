#!/bin/bash
# =============================================================================
#  setup.sh — forense-archivos-borrados
#  Descarga dos imágenes de prueba públicas de NIST (CFReDS, serie Deleted File
#  Recovery) e instala The Sleuth Kit para analizarlas.
#  Se ejecuta una sola vez al inicio del escenario.
# =============================================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

banner() { echo -e "\n${CYAN}[$1]${NC} $2"; }
ok()     { echo -e "${GREEN}  ✓${NC} $1"; }
warn()   { echo -e "${YELLOW}  ⚠${NC} $1"; }

BASE_URL="https://cfreds-archive.nist.gov/dfr-images"
IMAGENES="dfr-01-fat dfr-07-fat"

echo ""
echo "=============================================="
echo "  Preparando entorno — forense-archivos-borrados"
echo "=============================================="

# ── 1. Herramientas ────────────────────────────────────────────────────────
banner "1/4" "Instalando The Sleuth Kit..."
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    sleuthkit \
    bzip2 \
    curl
ok "The Sleuth Kit instalado (mmls, fsstat, fls, istat, icat)"

# ── 2. Descargar las imágenes de NIST ──────────────────────────────────────
banner "2/4" "Descargando las imágenes de prueba de NIST (unos 2 MB cada una)..."
mkdir -p /root/imagenes
cd /root/imagenes
for img in $IMAGENES; do
    curl -sf -o "$img.dd.bz2" "$BASE_URL/$img.dd.bz2"
    ok "$img.dd.bz2 descargada"
done

# ── 3. Descomprimir y registrar los hashes ─────────────────────────────────
banner "3/4" "Descomprimiendo (1 GB cada una) y registrando sus hashes..."
for img in $IMAGENES; do
    bunzip2 -f "$img.dd.bz2"
    chmod 444 "$img.dd"
    ok "$img.dd lista (solo lectura)"
done
sha256sum dfr-01-fat.dd dfr-07-fat.dd > /root/imagenes/hashes.sha256
chmod 444 /root/imagenes/hashes.sha256
ok "Hashes SHA-256 registrados en /root/imagenes/hashes.sha256"

# ── 4. Carpeta para lo recuperado ──────────────────────────────────────────
banner "4/4" "Preparando la carpeta de trabajo..."
mkdir -p /root/recuperados
ok "Lo que recuperes va en /root/recuperados"

# ── Resumen ──────────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo -e "${GREEN}  Entorno listo. Podés continuar con el Paso 1.${NC}"
echo "=============================================="
echo ""
echo "  Imágenes de disco (fuente: NIST CFReDS, serie Deleted File Recovery):"
echo "    /root/imagenes/dfr-01-fat.dd  → un archivo borrado por partición"
echo "    /root/imagenes/dfr-07-fat.dd  → archivos borrados y después sobrescritos"
echo ""
echo "  Registro de hashes: /root/imagenes/hashes.sha256"
echo "  Carpeta de trabajo: /root/recuperados"
echo ""
echo "  Próximo paso: comprobar que las imágenes no cambiaron."
echo "=============================================="
echo ""

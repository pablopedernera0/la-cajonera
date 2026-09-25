#!/bin/bash
# Genera tráfico HTTP contra la app, con un tope fijo para que la carga sea corta.
# Uso: carga_http.sh [peticiones] [simultáneas]   (por defecto: 1000 y 10)

TOTAL=${1:-1000}
PARALELO=${2:-10}

# Topes: la idea es ver el sistema trabajar, no saturar la máquina
[ "$TOTAL" -gt 3000 ] && TOTAL=3000
[ "$PARALELO" -gt 20 ] && PARALELO=20

echo "Enviando $TOTAL peticiones a http://127.0.0.1:8888/ ($PARALELO en simultáneo)..."
INICIO=$(date +%s.%N)
seq 1 "$TOTAL" | xargs -P "$PARALELO" -I{} curl -s -o /dev/null http://127.0.0.1:8888/
FIN=$(date +%s.%N)
echo "Listo en $(awk -v a="$INICIO" -v b="$FIN" 'BEGIN{printf "%.1f", b-a}') segundos."

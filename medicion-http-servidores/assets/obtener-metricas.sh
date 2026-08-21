#!/bin/bash
# =============================================================================
#  obtener-metricas.sh — mide tamaño y tiempo de respuesta de una URL pública
#  Uso: obtener-metricas.sh <url>
# =============================================================================

if [ -z "$1" ]; then
    echo "Uso: obtener-metricas.sh <url>"
    echo "Ejemplo: obtener-metricas.sh https://es.wikipedia.org/wiki/HTTP"
    exit 1
fi

URL="$1"

FORMATO="Código HTTP:          %{http_code}\n\
Tamaño descargado:     %{size_download} bytes\n\
Tiempo de conexión:    %{time_connect}s\n\
Tiempo primer byte:    %{time_starttransfer}s (TTFB)\n\
Tiempo total:          %{time_total}s\n\
Velocidad de descarga: %{speed_download} bytes/s\n"

echo ""
echo "=============================================="
echo "  Midiendo: $URL"
echo "=============================================="

echo ""
echo "--- Sin pedir compresión ---"
curl -s -o /dev/null --max-time 15 -w "$FORMATO" "$URL"

echo ""
echo "--- Pidiendo compresión gzip (Accept-Encoding: gzip) ---"
curl -s -o /dev/null --max-time 15 -H "Accept-Encoding: gzip" -w "$FORMATO" "$URL"

echo ""
echo "=============================================="
echo "  Copiá esta salida completa, o sacá una captura,"
echo "  para tu documentación."
echo "=============================================="
echo ""

#!/bin/bash
# Dispara 1000 peticiones contra el servidor simulado y avisa si conviene
# sumar procesos o memoria, según lo que se observó en este lote.
export LC_ALL=C  # sin esto, awk rompe las comparaciones numéricas en locales con coma decimal
N=1000
CONCURRENCIA=20
URL="http://localhost:8080/carga"
TMP=$(mktemp)

echo "Disparando $N peticiones (concurrencia $CONCURRENCIA) contra $URL ..."
seq 1 "$N" | xargs -P "$CONCURRENCIA" -I{} curl -s -o /dev/null -w "%{http_code} %{time_total}\n" "$URL" >> "$TMP"

total=$(wc -l < "$TMP")
fallidas=$(awk '$1 != 200' "$TMP" | wc -l)
exitosas=$((total - fallidas))
tiempo_prom=$(awk '$1 == 200 {sum+=$2; n++} END {if (n>0) printf "%.2f", sum/n; else print "0.00"}' "$TMP")
pct_fallidas=$(awk -v f="$fallidas" -v t="$total" 'BEGIN {printf "%.0f", (f/t)*100}')

echo ""
echo "Resultado de este lote:"
echo "  Exitosas: $exitosas / $total"
echo "  Fallidas: $fallidas / $total (${pct_fallidas}%)"
echo "  Tiempo de respuesta promedio (exitosas): ${tiempo_prom}s"
echo ""

if [ "$pct_fallidas" -gt 15 ]; then
    echo "⚠️  Con esta cantidad de peticiones, al servidor le está faltando memoria."
    echo "    Ejecutá: bash sumar_ram.sh"
elif awk -v t="$tiempo_prom" 'BEGIN{exit !(t > 0.4)}'; then
    echo "⚠️  Con este nivel de peticiones, al servidor le están faltando procesos."
    echo "    Ejecutá: bash sumar_cpu.sh"
else
    echo "✅ El servidor está aguantando bien esta carga."
fi

rm -f "$TMP"

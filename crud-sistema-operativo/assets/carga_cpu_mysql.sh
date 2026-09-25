#!/bin/bash
# Le pide a MySQL un trabajo de CPU fijo (calcular muchos hashes SHA2 seguidos) y mide
# cuánto tarda. Una sola conexión = un solo hilo de mysqld = como mucho un núcleo.
# La cantidad de trabajo es siempre la misma: lo que cambia entre corridas es cuánta
# CPU le deja usar el kernel.
# Uso: carga_cpu_mysql.sh [repeticiones]   (por defecto 1, máximo 5)

VUELTAS=5000000
REP=${1:-1}
[ "$REP" -gt 5 ] && REP=5

# SHA2 de RAND() y no de un texto fijo: con un texto fijo MySQL reusa el resultado
# y casi no trabaja.
echo "Pidiéndole a MySQL que calcule $VUELTAS hashes SHA2, $REP vez/veces (siempre el mismo trabajo)..."
INICIO=$(date +%s.%N)
for i in $(seq 1 "$REP"); do
    docker exec mysql mysql -uroot -pmysecretpassword \
        -e "SELECT BENCHMARK($VUELTAS, SHA2(RAND(), 256));" > /dev/null 2>&1
done
FIN=$(date +%s.%N)
echo "Tardó $(awk -v a="$INICIO" -v b="$FIN" 'BEGIN{printf "%.1f", b-a}') segundos."

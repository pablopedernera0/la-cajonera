#!/bin/bash
# Abre N conexiones a MySQL que quedan "dormidas" unos segundos (SELECT SLEEP),
# para poder contar cuántos hilos tiene mysqld mientras están abiertas.
# Uso: abrir_conexiones.sh [cantidad] [segundos]   (por defecto: 10 y 60)

N=${1:-10}
SEG=${2:-60}
[ "$N" -gt 50 ] && N=50
[ "$SEG" -gt 120 ] && SEG=120

for i in $(seq 1 "$N"); do
    docker exec mysql mysql -uroot -pmysecretpassword \
        -e "SELECT SLEEP($SEG);" > /dev/null 2>&1 &
done

echo "Abrí $N conexiones a MySQL. Cada una queda esperando $SEG segundos y después se cierra sola."
echo "Mientras tanto, contá los hilos de mysqld con:  ps -T -p \$(pgrep -x mysqld) | wc -l"

#!/bin/bash
# =============================================================================
#  buscar_lote.sh — mysql-joins-indices
#  Simula N usuarios que inician sesión: cada login busca a la persona por
#  su email en `padron`. Mide cuánto tarda el lote completo.
#  Uso: bash /root/buscar_lote.sh [N]     (N = cantidad de logins, default 10)
# =============================================================================

N=${1:-10}
TOTAL=$(docker exec mysql mysql --default-character-set=utf8mb4 -h127.0.0.1 -uroot -pmysecretpassword -N practica \
    -e "SELECT COUNT(*) FROM padron" 2>/dev/null)

if [ -z "$TOTAL" ] || [ "$TOTAL" -eq 0 ]; then
    echo "No encuentro la tabla padron. ¿Corriste bash /root/setup.sh?"
    exit 1
fi

INDICE=$(docker exec mysql mysql --default-character-set=utf8mb4 -h127.0.0.1 -uroot -pmysecretpassword -N practica \
    -e "SELECT COUNT(*) FROM information_schema.statistics
        WHERE table_schema='practica' AND table_name='padron' AND column_name='email'" 2>/dev/null)
if [ "$INDICE" -gt 0 ]; then ESTADO="CON índice sobre email"; else ESTADO="SIN índice sobre email"; fi

echo "Simulando $N logins contra un padrón de $TOTAL personas ($ESTADO)..."

# Todas las consultas van en una sola conexión, así se mide la base y no docker exec
INICIO=$(date +%s.%N)
for i in $(seq 1 "$N"); do
    ID=$(( (RANDOM * 32768 + RANDOM) % TOTAL + 1 ))
    echo "SELECT id, apellido, nombre FROM padron WHERE email = 'persona${ID}@correo.com.ar';"
done | docker exec -i mysql mysql --default-character-set=utf8mb4 -h127.0.0.1 -uroot -pmysecretpassword -N practica >/dev/null 2>&1
FIN=$(date +%s.%N)

awk -v i="$INICIO" -v f="$FIN" -v n="$N" 'BEGIN {
    t = f - i
    printf "  Tiempo total:       %.2f segundos\n", t
    printf "  Promedio por login: %.1f milisegundos\n", t / n * 1000
}'

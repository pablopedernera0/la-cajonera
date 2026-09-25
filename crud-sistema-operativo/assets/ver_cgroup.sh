#!/bin/bash
# Muestra el cgroup de un contenedor: dónde lo guarda el kernel y qué cuenta de él.
# Es exactamente lo que lee cAdvisor para dárselo a Prometheus.
# Uso: ver_cgroup.sh [contenedor]   (por defecto: mysql)

C=${1:-mysql}
PID=$(docker inspect -f '{{.State.Pid}}' "$C" 2>/dev/null)

if [ -z "$PID" ] || [ "$PID" = "0" ]; then
    echo "No encontré el contenedor '$C' corriendo. Probá con: docker ps"
    exit 1
fi

# En cgroup v2 hay una sola línea "0::/ruta"
RUTA=$(grep '^0::' "/proc/$PID/cgroup" | cut -d: -f3)
DIR="/sys/fs/cgroup$RUTA"

if [ -z "$RUTA" ] || [ ! -d "$DIR" ]; then
    echo "Este sistema no usa cgroup v2; la ruta del cgroup es distinta a la de la guía."
    cat "/proc/$PID/cgroup"
    exit 1
fi

echo ""
echo "Contenedor:        $C"
echo "PID en el host:    $PID"
echo "Cgroup:            $DIR"
echo ""
echo "── cpu.stat (tiempo de CPU acumulado, en microsegundos) ──"
cat "$DIR/cpu.stat"
echo ""
echo "── cpu.max (límite de CPU: 'cuota período', o 'max' si no hay límite) ──"
cat "$DIR/cpu.max"
echo ""
echo "── memoria ──"
echo "memory.current:  $(cat "$DIR/memory.current") bytes en uso"
echo "memory.max:      $(cat "$DIR/memory.max")"
echo ""

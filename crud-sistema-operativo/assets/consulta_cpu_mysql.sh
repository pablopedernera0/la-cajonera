#!/bin/bash
# Busca el ID del contenedor de mysql y muestra las consultas PromQL listas para pegar
# en Prometheus. cAdvisor identifica cada contenedor por su cgroup, no por su nombre.

ID=$(docker ps -qf "name=^mysql$")

if [ -z "$ID" ]; then
    echo "No encontré el contenedor de mysql corriendo. ¿Ya ejecutaste el setup.sh?"
    exit 1
fi

echo ""
echo "1) Contador crudo: segundos de CPU acumulados (comparalo con usage_usec de ver_cgroup.sh):"
echo ""
echo "container_cpu_usage_seconds_total{id=~\".*${ID}.*\"}"
echo ""
echo "2) Uso de CPU en este momento, en núcleos (1 = un núcleo entero, 0.5 = medio):"
echo ""
echo "irate(container_cpu_usage_seconds_total{id=~\".*${ID}.*\"}[20s])"
echo ""

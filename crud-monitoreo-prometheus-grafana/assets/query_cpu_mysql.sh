#!/bin/bash
# Busca el ID del contenedor de mysql y muestra la consulta PromQL lista para
# copiar y pegar en Prometheus o en un panel de Grafana. cAdvisor en este entorno
# identifica los contenedores por el ID de su cgroup, no por su nombre.

ID=$(docker ps -qf "name=mysql")

if [ -z "$ID" ]; then
    echo "No encontré ningún contenedor de mysql corriendo. ¿Ya ejecutaste el setup.sh?"
    exit 1
fi

echo ""
echo "Pegá esta consulta en Prometheus (Graph) o en el editor de un panel de Grafana:"
echo ""
echo "rate(container_cpu_usage_seconds_total{id=~\".*${ID}.*\"}[1m])"
echo ""

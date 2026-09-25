#!/bin/bash
# Arranca un contenedor con un límite de 32 MB de RAM y un proceso que pide memoria
# sin parar (tail sobre /dev/zero nunca encuentra un fin de línea y acumula todo).
# El kernel lo corta: eso es el OOM killer.

echo "Arrancando un contenedor con límite de 32 MB que va a pedir memoria sin parar..."
docker rm -f prueba-oom > /dev/null 2>&1 || true
docker run --name prueba-oom --memory=32m --memory-swap=32m \
    alpine sh -c 'tail /dev/zero' > /dev/null 2>&1
CODIGO=$?

echo ""
echo "El proceso terminó con código de salida: $CODIGO"
echo "¿Lo mató el OOM killer? $(docker inspect -f '{{.State.OOMKilled}}' prueba-oom)"
echo ""
echo "137 = 128 + 9 → el proceso recibió la señal 9 (SIGKILL) de parte del kernel."
docker rm prueba-oom > /dev/null

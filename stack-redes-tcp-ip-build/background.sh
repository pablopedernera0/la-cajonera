#!/bin/bash

# Actualizar repositorios silenciosamente
apt-get update -qq

# Instalar paquetes necesarios
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    isc-dhcp-server \
    bind9 \
    bind9utils \
    dnsutils \
    net-tools \
    iproute2

# Cargar módulo dummy para interfaz virtual
modprobe dummy

# Crear interfaz dummy0 y levantarla
ip link add dummy0 type dummy 2>/dev/null || true
ip link set dummy0 up

# Dejar isc-dhcp-server detenido para que el estudiante lo configure
systemctl stop isc-dhcp-server 2>/dev/null || true

# Dejar bind9 detenido para que el estudiante lo configure
systemctl stop bind9 2>/dev/null || true

echo "Entorno listo" > /tmp/background_done

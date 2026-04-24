#!/bin/bash
echo "================================================"
echo "  Preparando el entorno - Infraestructura Redes"
echo "================================================"
echo ""

echo "[1/4] Actualizando repositorios..."
apt-get update -qq

echo "[2/4] Instalando paquetes..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    isc-dhcp-server \
    bind9 \
    bind9utils \
    dnsutils \
    net-tools \
    iproute2 \
    inetutils-traceroute

echo "[3/4] Deteniendo servicios (los configurás vos)..."
systemctl stop isc-dhcp-server 2>/dev/null || true
systemctl stop bind9 2>/dev/null || true
systemctl disable isc-dhcp-server 2>/dev/null || true
systemctl disable bind9 2>/dev/null || true

echo "[4/4] Configurando interfaz virtual dummy0..."
modprobe dummy
ip link add dummy0 type dummy 2>/dev/null || true
ip link set dummy0 up

echo ""
echo "================================================"
echo "  Entorno listo. Podés continuar con el Paso 1."
echo "================================================"
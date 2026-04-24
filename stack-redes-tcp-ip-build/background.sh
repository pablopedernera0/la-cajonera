#!/bin/bash
set -euo pipefail
exec > /tmp/background.log 2>&1

echo "[background] Iniciando setup..."

# ── 1. Actualizar e instalar paquetes ──────────────────────────────────────────
echo "[background] Actualizando repositorios..."
apt-get update -qq

echo "[background] Instalando paquetes..."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    isc-dhcp-server \
    bind9 \
    bind9utils \
    dnsutils \
    net-tools \
    iproute2

# ── 2. Cargar módulo dummy con reintentos ──────────────────────────────────────
echo "[background] Cargando módulo dummy..."
for i in 1 2 3 4 5; do
    if modprobe dummy 2>/dev/null; then
        echo "[background] Módulo dummy cargado (intento $i)"
        break
    fi
    echo "[background] Intento $i fallido, reintentando en 3s..."
    sleep 3
done

# Verificar que el módulo quedó cargado
if ! lsmod | grep -q "^dummy"; then
    echo "[background] ADVERTENCIA: módulo dummy no disponible en este kernel"
fi

# ── 3. Crear interfaz dummy0 ───────────────────────────────────────────────────
echo "[background] Creando interfaz dummy0..."
if ip link show dummy0 &>/dev/null; then
    echo "[background] dummy0 ya existe"
else
    ip link add dummy0 type dummy 2>/dev/null && echo "[background] dummy0 creada" || echo "[background] No se pudo crear dummy0"
fi

ip link set dummy0 up 2>/dev/null && echo "[background] dummy0 UP" || echo "[background] No se pudo levantar dummy0"

# ── 4. Detener servicios para que el estudiante los configure ──────────────────
echo "[background] Deteniendo servicios..."
systemctl stop isc-dhcp-server 2>/dev/null || true
systemctl stop bind9          2>/dev/null || true

# Deshabilitar para evitar que arranquen solos al boot
systemctl disable isc-dhcp-server 2>/dev/null || true
systemctl disable bind9           2>/dev/null || true

# ── 5. Señal de finalización ───────────────────────────────────────────────────
echo "[background] Setup completo."
echo "done" > /tmp/background_done
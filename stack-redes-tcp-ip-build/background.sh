#!/bin/bash
# NO usar set -e aquí: en Killercoda varios comandos retornan non-zero
# aunque funcionan, y set -e mataría el script silenciosamente.

LOG=/tmp/background.log
exec > "$LOG" 2>&1

echo "[$(date)] Iniciando setup..."

# ── 1. Actualizar e instalar paquetes ──────────────────────────────────────────
echo "[$(date)] Actualizando repositorios..."
apt-get update -qq || echo "[WARN] apt-get update falló, continuando..."

echo "[$(date)] Instalando paquetes..."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    isc-dhcp-server \
    bind9 \
    bind9utils \
    dnsutils \
    net-tools \
    iproute2 || echo "[WARN] Algún paquete no instaló correctamente"

# ── 4. Detener servicios ───────────────────────────────────────────────────────
echo "[$(date)] Deteniendo servicios..."
systemctl stop isc-dhcp-server 2>/dev/null || true
systemctl stop bind9           2>/dev/null || true
systemctl disable isc-dhcp-server 2>/dev/null || true
systemctl disable bind9           2>/dev/null || true

# ── 5. Señal de finalización ───────────────────────────────────────────────────
echo "[$(date)] Setup completo."
echo "done" > /tmp/background_done
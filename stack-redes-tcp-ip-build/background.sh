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

# ── 2. Cargar módulo dummy con reintentos ──────────────────────────────────────
echo "[$(date)] Cargando módulo dummy..."
DUMMY_OK=false
for i in 1 2 3 4 5; do
    modprobe dummy && DUMMY_OK=true && echo "[$(date)] Módulo dummy cargado (intento $i)" && break
    echo "[$(date)] Intento $i fallido, reintentando en 5s..."
    sleep 5
done
$DUMMY_OK || echo "[WARN] Módulo dummy no disponible en este kernel"

# ── 3. Crear interfaz dummy0 ───────────────────────────────────────────────────
echo "[$(date)] Configurando interfaz dummy0..."
if ip link show dummy0 > /dev/null 2>&1; then
    echo "[$(date)] dummy0 ya existe"
else
    ip link add dummy0 type dummy 2>&1 || echo "[WARN] No se pudo crear dummy0"
fi
ip link set dummy0 up 2>&1 || echo "[WARN] No se pudo levantar dummy0"
ip link show dummy0 2>&1 || echo "[WARN] dummy0 no visible"

# ── 4. Detener servicios ───────────────────────────────────────────────────────
echo "[$(date)] Deteniendo servicios...]"
systemctl stop isc-dhcp-server 2>/dev/null || true
systemctl stop bind9           2>/dev/null || true
systemctl disable isc-dhcp-server 2>/dev/null || true
systemctl disable bind9           2>/dev/null || true

# ── 5. Señal de finalización ───────────────────────────────────────────────────
echo "[$(date)] Setup completo."
echo "done" > /tmp/background_done
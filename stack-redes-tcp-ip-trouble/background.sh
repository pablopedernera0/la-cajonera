#!/bin/bash

apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    isc-dhcp-server \
    bind9 \
    bind9utils \
    dnsutils \
    net-tools \
    iproute2

# Cargar módulo dummy
modprobe dummy
ip link add dummy0 type dummy 2>/dev/null || true
ip link set dummy0 up

# Asignar IP a dummy0
ip addr add 10.0.0.1/24 dev dummy0 2>/dev/null || true

# --- CONFIGURAR DHCP con error intencional ---
# Error: interfaz incorrecta (enp2s0 no existe)
cat > /etc/default/isc-dhcp-server << 'EOF'
INTERFACESv4="enp2s0"
INTERFACESv6=""
EOF

cat > /etc/dhcp/dhcpd.conf << 'EOF'
default-lease-time 600;
max-lease-time 7200;

subnet 10.0.0.0 netmask 255.255.255.0 {
  range 10.0.0.100 10.0.0.200;
  option routers 10.0.0.1;
  option domain-name-servers 8.8.8.8;
  option domain-name "laboratorio.local";
}
EOF

# --- CONFIGURAR DNS con error intencional ---
# Error: indentación incorrecta en named.conf.options (falta llave de cierre)
cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
    allow-query { any; };
    dnssec-validation no;
    listen-on { any; };
EOF
# La llave de cierre de options { falta intencionalmente

cat > /etc/bind/named.conf.local << 'EOF'
zone "laboratorio.local" {
    type master;
    file "/etc/bind/zones/laboratorio.local.db";
};
EOF

mkdir -p /etc/bind/zones

# Error en el archivo de zona: serial con formato inválido y falta punto en NS
cat > /etc/bind/zones/laboratorio.local.db << 'EOF'
$TTL    604800
@       IN      SOA     ns1.laboratorio.local. admin.laboratorio.local. (
                        2024010101
                        604800
                        86400
                        2419200
                        604800 )

@       IN      NS      ns1.laboratorio.local
ns1     IN      A       10.0.0.1
server1 IN      A       10.0.0.10
server2 IN      A       10.0.0.11
EOF
# Error: falta el punto final en "ns1.laboratorio.local" del registro NS

# Intentar iniciar los servicios (van a fallar, eso es intencional)
systemctl start isc-dhcp-server 2>/dev/null || true
systemctl start named 2>/dev/null || true

echo "Entorno listo" > /tmp/background_done

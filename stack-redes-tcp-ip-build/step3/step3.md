# Paso 3 — Servidor DHCP con isc-dhcp-server

Un servidor DHCP asigna direcciones IP automáticamente a los dispositivos que se conectan a la red. En este paso vamos a configurar `isc-dhcp-server` para que administre el pool de IPs de la red `10.0.0.0/24`.

## 3.1 — Entender la estructura de configuración

El archivo principal de configuración es `/etc/dhcp/dhcpd.conf`. Vamos a ver qué trae por defecto:

```
cat /etc/dhcp/dhcpd.conf
```

## 3.2 — Configurar la interfaz que escucha el servidor

El servidor DHCP necesita saber en qué interfaz debe escuchar. Editá el archivo:

```
cat > /etc/default/isc-dhcp-server << 'EOF'
INTERFACESv4="dummy0"
INTERFACESv6=""
EOF
```

## 3.3 — Escribir la configuración del servidor

Ahora configuramos el pool de direcciones. Reemplazá el contenido de `dhcpd.conf`:

```
cat > /etc/dhcp/dhcpd.conf << 'EOF'
# Tiempo de vigencia de las IPs asignadas
default-lease-time 600;
max-lease-time 7200;

# Configuración de la red 10.0.0.0/24
subnet 10.0.0.0 netmask 255.255.255.0 {

  # Rango de IPs disponibles para asignar
  range 10.0.0.100 10.0.0.200;

  # Gateway por defecto que se informa a los clientes
  option routers 10.0.0.1;

  # Servidor DNS que se informa a los clientes
  option domain-name-servers 8.8.8.8;

  # Nombre de dominio local
  option domain-name "laboratorio.local";
}
EOF
```

**¿Qué significa cada directiva?**

| Directiva | Descripción |
|-----------|-------------|
| `default-lease-time` | Tiempo en segundos que dura la IP asignada si el cliente no pide un tiempo específico |
| `max-lease-time` | Tiempo máximo que puede durar una asignación |
| `range` | Pool de IPs disponibles para distribuir |
| `option routers` | Gateway que el servidor informa a los clientes |
| `option domain-name-servers` | DNS que el servidor informa a los clientes |

## 3.4 — Iniciar el servicio

```
systemctl start isc-dhcp-server
```

## 3.5 — Verificar el estado

```
systemctl status isc-dhcp-server
```

El servicio debe aparecer como `active (running)`. Si aparece `failed`, revisá la configuración con:

```
journalctl -u isc-dhcp-server -n 20
```

## 3.6 — Habilitar inicio automático

```
systemctl enable isc-dhcp-server
```

## 3.7 — Verificar que el servidor está escuchando

```
ss -ulnp | grep dhcp
```

Deberías ver el proceso escuchando en el puerto 67 (puerto estándar de DHCP).

> **Captura sugerida:** El archivo `/etc/dhcp/dhcpd.conf` y la salida de `systemctl status isc-dhcp-server`.

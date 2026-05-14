# Paso 3 — Reparar el servidor DHCP

En este paso vas a identificar y corregir el error en la configuración de `isc-dhcp-server`.

## 3.1 — Leer los logs del servicio

```
journalctl -u isc-dhcp-server -n 30
```

Buscá la línea que describe el error. Los logs de `isc-dhcp-server` suelen ser bastante claros — mencionan directamente qué interfaz o qué configuración falló.

## 3.2 — Ver la configuración de la interfaz

```
cat /etc/default/isc-dhcp-server
```

Este archivo le dice al servidor en qué interfaz debe escuchar.

## 3.3 — Comparar con las interfaces disponibles

```
ip link show
```

¿La interfaz configurada en `/etc/default/isc-dhcp-server` existe en el sistema?

## 3.4 — Reparar la configuración

```
nano /etc/default/isc-dhcp-server
```

Corregí el nombre de la interfaz para que coincida con la interfaz real donde está configurada la red `10.0.0.0/24`.

El archivo correcto debe verse así:

```
INTERFACESv4="dummy0"
INTERFACESv6=""
```

## 3.5 — Verificar que la interfaz tiene IP asignada

El servidor DHCP necesita que la interfaz donde escucha tenga una IP dentro de la red que va a administrar:

```
ip addr show dummy0
```

Debe mostrar la IP `10.0.0.1/24`. Si no la tiene, asignala:

```
ip addr add 10.0.0.1/24 dev dummy0
```

## 3.6 — Iniciar el servicio

```
systemctl start isc-dhcp-server
systemctl status isc-dhcp-server
```

## 3.7 — Verificar que está escuchando

```
ss -ulnp | grep 67
```

Debe aparecer el proceso `dhcpd` escuchando en el puerto 67.

## 3.8 — Verificar la configuración del pool

```
cat /etc/dhcp/dhcpd.conf
```

Confirmá que el pool, el gateway y el DNS están correctamente definidos.

> **Captura sugerida:** `systemctl status isc-dhcp-server` en estado `active (running)` y `ss -ulnp | grep 67` mostrando el puerto en escucha.

## 3.9 — Verificación final

Con ambos servicios reparados, ejecutá la verificación completa:

```
echo "=== Estado de servicios ==="
systemctl is-active isc-dhcp-server
systemctl is-active named

echo "=== Puertos en escucha ==="
ss -ulnp | grep -E "67|53"

echo "=== Resolución DNS ==="
dig @127.0.0.1 server1.laboratorio.local +short
dig @127.0.0.1 server2.laboratorio.local +short
```

Si todo está correcto:
- Ambos servicios responden `active`
- Los puertos 67 (DHCP) y 53 (DNS) están en escucha
- Los nombres se resuelven correctamente

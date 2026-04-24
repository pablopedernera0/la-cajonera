# Paso 5 — Comandos de diagnóstico

Un profesional de redes necesita poder diagnosticar problemas rápidamente. En este paso vas a practicar los comandos más usados en el día a día.

## 5.1 — Diagnóstico de conectividad

### ping — verificar que un host es alcanzable

```
ping -c 4 8.8.8.8          # Conectividad a internet
ping -c 4 10.0.0.1         # Conectividad a la interfaz local
ping -c 4 127.0.0.1        # Loopback (siempre debe funcionar)
```

**Qué mirar:** tiempo de respuesta (ms) y pérdida de paquetes. Si hay pérdida, hay un problema en el camino.

### traceroute — ver el camino que toma un paquete

```
traceroute 8.8.8.8
```

Muestra cada salto (router) por el que pasa el paquete hasta llegar al destino.

## 5.2 — Diagnóstico de DNS

### dig — consulta DNS detallada

```
# Resolver un nombre
dig @127.0.0.1 server1.laboratorio.local

# Ver solo la respuesta sin información extra
dig @127.0.0.1 server1.laboratorio.local +short

# Consultar un registro específico
dig @127.0.0.1 laboratorio.local NS

# Consultar al DNS de Google para comparar
dig @8.8.8.8 google.com
```

### nslookup — consulta DNS interactiva

```
nslookup server1.laboratorio.local 127.0.0.1
nslookup google.com 8.8.8.8
```

**Diferencia clave entre dig y nslookup:**
`dig` muestra información técnica detallada (útil para diagnóstico). `nslookup` es más simple y fácil de leer (útil para verificaciones rápidas).

## 5.3 — Diagnóstico de servicios

### systemctl — estado de servicios

```
systemctl status isc-dhcp-server
systemctl status bind9
```

**Qué mirar:** la línea `Active:`. Puede ser:
- `active (running)` — el servicio está funcionando
- `inactive (dead)` — el servicio está detenido
- `failed` — el servicio intentó iniciar pero falló

### journalctl — logs del sistema

```
# Ver los últimos logs de un servicio
journalctl -u isc-dhcp-server -n 30

# Ver logs en tiempo real
journalctl -u bind9 -f
```

`journalctl` es la primera herramienta a usar cuando un servicio falla — los logs casi siempre dicen exactamente qué salió mal.

## 5.4 — Diagnóstico de puertos y conexiones

### ss — ver puertos en uso

```
# Ver todos los puertos UDP en escucha
ss -ulnp

# Ver todos los puertos TCP en escucha
ss -tlnp

# Filtrar por un puerto específico
ss -ulnp | grep 53    # DNS
ss -ulnp | grep 67    # DHCP
```

### netstat (alternativa clásica)

```
netstat -tulnp
```

## 5.5 — Diagnóstico de interfaces

```
# Estado de todas las interfaces
ip link show

# Direcciones IP asignadas
ip addr show

# Tabla de ruteo
ip route show

# Estadísticas de tráfico por interfaz
ip -s link show enp1s0
```

## 5.6 — Escenario de práctica

Ejecutá la siguiente secuencia y respondé las preguntas:

```
systemctl status isc-dhcp-server
ss -ulnp | grep 67
dig @127.0.0.1 server1.laboratorio.local +short
journalctl -u bind9 -n 5
```

**Preguntas:**
1. ¿El servidor DHCP está activo y escuchando en el puerto correcto?
2. ¿El servidor DNS resuelve correctamente `server1.laboratorio.local`?
3. ¿Qué información aparece en los últimos logs de bind9?

> **Captura sugerida:** La salida de `ss -ulnp | grep 67` y `dig @127.0.0.1 server1.laboratorio.local +short`.

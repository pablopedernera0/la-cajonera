# Paso 1 — Interfaces de red

Antes de configurar cualquier cosa, es fundamental entender qué interfaces de red tiene el sistema y cuál es su estado actual.

## 1.1 — Listar interfaces con ip

El comando moderno para gestionar interfaces en Linux es `ip`:

```
ip link show
```

Vas a ver algo similar a esto:

```
1: lo: <LOOPBACK,UP,LOWER_UP> ...
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> ...
```

**¿Qué es cada interfaz?**

| Interfaz | Tipo | Descripción |
|----------|------|-------------|
| `lo` | Loopback | Interfaz interna del sistema. Siempre tiene la IP 127.0.0.1. El tráfico nunca sale a la red. |
| `enp1s0` | Ethernet | Interfaz física conectada a la red del entorno. **No la modificar.** |
| `dummy0` | Virtual | Interfaz simulada. La usaremos para practicar configuración sin riesgo. |

## 1.2 — Ver direcciones IP asignadas

```
ip addr show
```

Para ver solo una interfaz específica:

```
ip addr show enp1s0
ip addr show dummy0
```

Notá que `dummy0` todavía no tiene dirección IP asignada. Eso lo vas a resolver en el próximo paso.

## 1.3 — Ver la tabla de ruteo

```
ip route show
```

Identificá cuál es la gateway por defecto (línea que dice `default via`). Esa es la puerta de salida de tu red hacia internet.

## 1.4 — Verificar conectividad actual

```
ping -c 4 8.8.8.8
```

Confirmá que el entorno tiene conectividad antes de continuar.

> **Captura sugerida:** `ip addr show` e `ip route show`.

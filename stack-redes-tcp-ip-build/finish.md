# ¡Escenario completado!

Configuraste desde cero los servicios de red más comunes en infraestructura Linux.

## Lo que hiciste

- **Interfaces de red** — exploraste el entorno con `ip link show` e `ip addr show`, entendiste la diferencia entre interfaz física, loopback y virtual
- **IP estática** — configuraste `dummy0` con la IP `10.0.0.1/24` usando Netplan
- **Servidor DHCP** — configuraste `isc-dhcp-server` con un pool de IPs para la red `10.0.0.0/24`, con gateway y DNS definidos
- **Servidor DNS** — configuraste `bind9` con la zona `laboratorio.local` y verificaste la resolución con `dig` y `nslookup`
- **Diagnóstico** — practicaste los comandos esenciales: `ping`, `dig`, `ss`, `systemctl`, `journalctl`

## Comandos clave para recordar

| Comando | Para qué sirve |
|---------|----------------|
| `ip addr show` | Ver IPs asignadas a las interfaces |
| `ip route show` | Ver la tabla de ruteo |
| `netplan apply` | Aplicar cambios de configuración de red |
| `systemctl status <servicio>` | Ver el estado de un servicio |
| `journalctl -u <servicio> -n 30` | Ver los últimos logs de un servicio |
| `dig @<servidor> <nombre>` | Consultar un servidor DNS específico |
| `ss -ulnp` | Ver puertos UDP en escucha |
| `named-checkzone` | Validar un archivo de zona DNS antes de aplicarlo |

## Próximo paso

En el siguiente escenario vas a trabajar con un entorno **intencionalmente roto**. Tu tarea va a ser diagnosticar qué falló y repararlo usando las herramientas que practicaste hoy.

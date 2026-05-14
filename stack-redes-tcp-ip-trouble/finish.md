# ¡Escenario completado!

Diagnosticaste y reparaste dos servicios de red con errores de configuración reales.

## Los errores que encontraste y reparaste

### named (bind9)
1. **`named.conf.options`** — faltaba la llave de cierre `};` del bloque `options`. Error de sintaxis que impide que el servicio inicie.
2. **Archivo de zona** — el registro `NS` tenía el nombre sin punto final. En archivos de zona, los nombres de dominio completos (FQDN) siempre deben terminar con `.`

### isc-dhcp-server
1. **`/etc/default/isc-dhcp-server`** — la interfaz configurada (`enp2s0`) no existía en el sistema. El servidor no puede escuchar en una interfaz que no existe.

## El proceso de troubleshooting

El flujo que seguiste es el estándar para cualquier problema de servicios en Linux:

```
systemctl status <servicio>
        ↓
journalctl -u <servicio> -n 30
        ↓
Identificar el archivo y la línea con error
        ↓
Corregir el archivo
        ↓
systemctl start <servicio>
        ↓
Verificar funcionamiento
```

## Para seguir practicando

Este escenario puede repetirse con diferentes tipos de errores:
- Errores de permisos en archivos de zona
- Pool DHCP mal definido (rango fuera de la subred)
- Registros A con IPs mal formateadas
- Servicio configurado para escuchar en una IP que no existe

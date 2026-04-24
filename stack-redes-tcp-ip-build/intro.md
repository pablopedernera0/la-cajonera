# Configuración de servicios de red en Linux

En este escenario vas a configurar interfaces de red, un servidor DHCP y un servidor DNS local en Ubuntu Server, y a practicar las herramientas de diagnóstico más usadas en producción.

## Preparar el entorno

El entorno necesita una interfaz de red virtual para practicar sin riesgo.
Ejecutá estos comandos antes de continuar:

```bash
modprobe dummy
ip link add dummy0 type dummy
ip link set dummy0 up
```

Verificá que la interfaz existe:

```bash
ip link show dummy0
```

Si ves `dummy0` en la lista, estás listo para continuar.

## Lo que vas a aprender

- Identificar y configurar interfaces de red con `ip` y Netplan
- Asignar una IP estática a una interfaz virtual (`dummy0`)
- Instalar y configurar `isc-dhcp-server`
- Resolver nombres locales con `bind9`
- Usar `ping`, `dig`, `ss` y `journalctl` para diagnosticar problemas

¡Empecemos!
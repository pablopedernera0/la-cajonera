# Configuración de servicios de red en Linux

En este escenario vas a configurar interfaces de red, un servidor DHCP y un servidor DNS local en Ubuntu Server, y a practicar las herramientas de diagnóstico más usadas en producción.

## Preparar el entorno

El entorno necesita configurarse, hay que instalar servicios y una interfaz de red virtual para practicar sin riesgo.
Ejecutá este comando antes de continuar:

```bash
bash /root/setup.sh
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
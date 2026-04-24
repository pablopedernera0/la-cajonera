# Configuración de servicios de red en Linux

En este escenario vas a configurar interfaces de red, un servidor DHCP y un servidor DNS local en Ubuntu Server, y a practicar las herramientas de diagnóstico más usadas en producción.

## Antes de empezar — esperá que el entorno esté listo

El entorno se está preparando en segundo plano (instalando paquetes y configurando interfaces virtuales). Ejecutá este comando y esperá el mensaje **"Entorno listo"** antes de continuar:

```bash
while [ ! -f /tmp/background_done ]; do
  echo "Preparando entorno..."; sleep 3
done && echo "Entorno listo ✓"
```

> ℹ️ Si querés ver el detalle de lo que hizo el script de fondo, revisá `/tmp/background.log`.

## Lo que vas a aprender

- Identificar y configurar interfaces de red con `ip` y Netplan
- Asignar una IP estática a una interfaz virtual (`dummy0`)
- Instalar y configurar `isc-dhcp-server`
- Resolver nombres locales con `bind9`
- Usar `ping`, `dig`, `ss` y `journalctl` para diagnosticar problemas

¡Empecemos!
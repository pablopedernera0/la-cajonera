# Troubleshooting de servicios de red

## Preparar el entorno

El entorno necesita configurarse, hay que instalar servicios y una interfaz de red virtual para practicar sin riesgo.
Ejecutá este comando antes de continuar:

```bash
bash /root/setup.sh
```

El entorno tiene `isc-dhcp-server` y `bind9` instalados y configurados, pero **ninguno de los dos está funcionando correctamente**.

Tu tarea es diagnosticar qué falló en cada servicio y repararlo.

## Reglas del escenario

- No hay pistas directas. Usá las herramientas de diagnóstico para encontrar los errores.
- Cada servicio tiene al menos un error de configuración.
- El objetivo es que ambos servicios queden en estado `active (running)` y funcionando correctamente.

## El síntoma reportado

> "Un equipo puede hacer ping a otros equipos de la red pero no puede resolver nombres de dominio. Además, los dispositivos nuevos no reciben dirección IP al conectarse."

## Antes de empezar

Verificá que el entorno esté listo:

```
ls /tmp/background_done
```

Luego verificá el estado inicial de los servicios:

```
systemctl status isc-dhcp-server
systemctl status bind9
```

Ambos deberían aparecer como `failed`. Ese es el punto de partida.

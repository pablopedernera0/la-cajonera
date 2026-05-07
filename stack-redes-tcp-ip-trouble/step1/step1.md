# Paso 1 — Diagnóstico inicial

Antes de tocar cualquier archivo de configuración, hay que entender exactamente qué está fallando y por qué.

## 1.1 — Verificar el estado de los servicios

```
systemctl status isc-dhcp-server
systemctl status bind9
```

Prestá atención a los mensajes de error que aparecen debajo del estado.

## 1.2 — Leer los logs

Los logs son la primera fuente de verdad cuando un servicio falla:

```
journalctl -u isc-dhcp-server -n 30
journalctl -u bind9 -n 30
```

**¿Qué buscar en los logs?**
- Mensajes que digan `error`, `failed`, `cannot`, `invalid`
- Referencias a archivos de configuración con números de línea
- Nombres de interfaces o archivos que no existen

## 1.3 — Verificar interfaces disponibles

```
ip link show
```

Comparar las interfaces que existen con las que están configuradas en los servicios.

## 1.4 — Verificar sintaxis de los archivos de configuración

Para bind9, existe un comando específico para verificar la configuración:

```
named-checkconf
named-checkzone laboratorio.local /etc/bind/zones/laboratorio.local.db
```

Para DHCP, podés verificar el archivo de configuración de la interfaz:

```
cat /etc/default/isc-dhcp-server
```

## 1.5 — Registrar los errores encontrados

Antes de continuar, anotá:

1. ¿Qué error aparece en los logs de `isc-dhcp-server`?
2. ¿Qué error aparece en los logs de `bind9`?
3. ¿Qué dice `named-checkconf`?
4. ¿Qué dice `named-checkzone`?

> En el próximo paso vas a reparar los errores que encontraste.

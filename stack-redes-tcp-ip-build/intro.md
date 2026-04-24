# Configuración de servicios de red en Linux

En este escenario vas a trabajar sobre un entorno **Ubuntu Server 22.04** configurando los servicios de red más comunes en infraestructura Linux.

## ¿Qué vas a hacer?

- Explorar las interfaces de red disponibles en el sistema
- Asignar una dirección IP estática usando **Netplan**
- Instalar y configurar un servidor **DHCP** con `isc-dhcp-server`
- Configurar un servidor **DNS local** con `bind9`
- Usar herramientas de diagnóstico de red

## Entorno de trabajo

El sistema ya tiene instalados los paquetes necesarios. Tu trabajo es configurarlos.

> **Nota:** Para proteger la conectividad del entorno, la configuración de IP estática se realizará sobre una interfaz virtual llamada `dummy0`. Esta interfaz es funcionalmente equivalente a una interfaz física y se usa habitualmente en laboratorios y entornos de testing.

## Antes de empezar

Verificá que el entorno esté listo ejecutando:

```
ls /tmp/background_done
```

Si el archivo existe, podés continuar. Si no aparece, esperá unos segundos y volvé a intentarlo.

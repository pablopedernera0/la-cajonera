# Paso 1 — Cómo está armado el simulador

## El servidor

El entorno tiene corriendo un servidor chico en el puerto 8080, con dos "perillas"
internas:

- **Workers**: cuántos procesos tiene para atender peticiones en paralelo.
- **RAM**: cuánta memoria tiene para sostener peticiones en cola.

Arranca con **1 worker y 1 GB de RAM** — deliberadamente poco, para que se note rápido
dónde aprieta. Podés ver el estado actual en cualquier momento:

```bash
curl http://localhost:8080/status
```

O abrirlo en el navegador desde la pestaña de tráfico del entorno, en el puerto 8080. La
página se actualiza sola cada 5 segundos.

> **Aclaración importante:** "sumar RAM" o "sumar CPU" en esta práctica no le agrega
> recursos reales al contenedor — Killercoda no permite eso. Es una simulación: el
> servidor lleva la cuenta de cuánta capacidad "tiene" y se comporta según eso. La lógica
> de fondo (agregar procesos resuelve las esperas, agregar memoria resuelve las caídas) es
> la misma que en un servidor real.

## El generador de carga

`subir_carga.sh` dispara **1000 peticiones** contra el servidor y te muestra cuántas
salieron bien, cuántas fallaron, y el tiempo de respuesta promedio:

```bash
subir_carga.sh
```

Al final del resumen, el script te dice si conviene sumar procesos, sumar memoria, o si el
servidor está aguantando bien esa carga — según lo que efectivamente midió en ese lote, no
según ningún número que el servidor "sepa" de antemano.

Todavía no lo corras. En el próximo paso vas a usarlo para encontrar el primer problema.

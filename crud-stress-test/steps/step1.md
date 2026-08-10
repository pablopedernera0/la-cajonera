# Paso 1 — Conceptos de stress testing

Antes de generar tráfico, conviene tener claro qué vamos a medir. Cualquier herramienta de carga (real o liviana, como la de esta práctica) reporta básicamente cuatro cosas.

## 1.1 — Throughput

Es la cantidad de peticiones que el servidor logra atender por segundo (**requests/segundo**). Es la métrica más directa de capacidad: cuánto tráfico aguanta la infraestructura tal como está configurada hoy.

## 1.2 — Latencia

Es el tiempo que tarda cada petición individual en resolverse. Una app puede tener buen throughput y aun así tener picos de latencia que arruinan la experiencia de algunos usuarios — por eso interesa mirar no solo el promedio, sino cómo varía entre peticiones.

## 1.3 — Concurrencia

Es la cantidad de peticiones que se disparan **al mismo tiempo**. No es lo mismo mandar 50 peticiones de a una que mandar 50 con 5 en simultáneo — la segunda forma es la que realmente pone a prueba el servidor.

## 1.4 — Tasa de error

Peticiones que fallan, dan timeout o devuelven un código de error. Un servidor puede seguir "funcionando" mientras descarta cada vez más peticiones — la tasa de error es la señal de que ya llegó a su límite.

## 1.5 — Qué vamos a usar

Vamos a medir con un loop de **`curl`** combinado con `xargs` para mandar varias peticiones en paralelo — ambas son herramientas de uso general que ya están en cualquier instalación de Linux, no un binario dedicado a pruebas de carga. Confirmá que las tenés:

```bash
curl --version | head -1
xargs --version | head -1
```

> Con estos cuatro conceptos en mente (throughput, latencia, concurrencia, tasa de error), pasá al Paso 2 para generar la primera carga.

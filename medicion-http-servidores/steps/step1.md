# Paso 1 — Qué vamos a medir y con qué

## El script

El entorno ya tiene instalado `obtener-metricas.sh`, que recibe **una URL como único parámetro** y le hace dos pedidos con `curl`: uno normal, y uno pidiendo compresión (`Accept-Encoding: gzip`) — la misma técnica que se usó para medir los datos de la Clase 1.

```bash
obtener-metricas.sh <url>
```

Probalo contra cualquier sitio para ver el formato de salida:

```bash
obtener-metricas.sh https://es.wikipedia.org/wiki/HTTP
```

## Qué significa cada métrica

| Métrica | Qué es |
|---|---|
| **Código HTTP** | Si el pedido se resolvió bien (`200`) o no |
| **Tamaño descargado** | Cuántos bytes viajaron en la respuesta |
| **Tiempo de conexión** | Cuánto tardó en establecerse la conexión TCP/TLS, antes de pedir nada |
| **Tiempo primer byte (TTFB)** | Cuánto tardó el servidor en empezar a responder — tiempo de "pensar" del servidor |
| **Tiempo total** | Cuánto tardó todo el intercambio, de punta a punta |
| **Velocidad de descarga** | Bytes por segundo, resultado de tamaño ÷ tiempo |

> El TTFB es especialmente importante: una página que tarda mucho en el primer byte casi siempre indica que el **servidor** está lento (mucho procesamiento, una consulta a base de datos pesada), no la red.

## Por qué se mide dos veces (con y sin gzip)

La primera medición muestra el tamaño "en crudo". La segunda, pidiendo compresión, muestra lo que realmente viajaría en un navegador real — que siempre pide gzip. En páginas HTML grandes la diferencia suele ser notable; en respuestas JSON chicas, casi no cambia. Vas a comprobarlo vos mismo en los próximos pasos.

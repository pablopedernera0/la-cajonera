# ¡Escenario completado!

Mediste con `curl`, contra sitios públicos reales, la diferencia de peso y tiempo de respuesta entre una página HTML completa y un backend JSON — la misma comparación de la Clase 1, pero con datos que generaste vos.

## Lo que hiciste

- Corriste `obtener-metricas.sh <url>` contra un sitio que devuelve HTML completo
- Corriste el mismo script contra un backend que solo devuelve JSON
- Leíste tamaño descargado, tiempo de conexión, TTFB y tiempo total con `curl -w`
- Comparaste el efecto de pedir compresión (`Accept-Encoding: gzip`)
- Armaste tu propia tabla comparativa y la documentaste con capturas de pantalla

## Comandos clave para recordar

| Comando | Para qué sirve |
|---|---|
| `curl -s -o /dev/null -w "..."` | Medir una respuesta sin imprimir su contenido, solo sus métricas |
| `%{size_download}` | Tamaño de la respuesta, en bytes |
| `%{time_starttransfer}` | TTFB — tiempo hasta el primer byte de respuesta |
| `%{time_total}` | Tiempo total del intercambio |
| `-H "Accept-Encoding: gzip"` | Pedirle al servidor la versión comprimida, como hace cualquier navegador |

## Conceptos clave

**TTFB (Time To First Byte)** — cuánto tarda el servidor en empezar a responder. Un TTFB alto suele indicar procesamiento pesado del lado del servidor, no un problema de red.

**Tamaño de la respuesta** — multiplicado por la cantidad de usuarios, es lo que define el ancho de banda que necesita un servidor (Clase 1).

**HTML completo vs. JSON** — misma información, formatos con costos de servidor y de red muy distintos. La elección de arquitectura impacta directo en el dimensionamiento.

## Próximo paso

Estos son los mismos números que, a mayor escala, usás para completar la fórmula de usuarios concurrentes y la tabla de CPU/RAM de la Clase 2 — ahora aplicados a tu propio proyecto EIDAS.

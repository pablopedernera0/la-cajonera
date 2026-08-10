# Paso 4 — Armando la línea de tiempo del incidente

Ya identificaste tres eventos por separado. Ahora vamos a ordenarlos en una sola línea de tiempo, como haría un informe de incidente real.

## 4.1 — Los tres momentos, uno al lado del otro

Pico de carga:

```bash
grep '"GET / ' /root/crud-python/app.log | awk -F'[][]' '{print $2}' | sort -u
```

Fuerza bruta:

```bash
grep '"POST /login' /root/crud-python/app.log | awk '{print $9}' | paste - <(grep '"POST /login' /root/crud-python/app.log | awk -F'[][]' '{print $2}')
```

Inyección SQL:

```bash
docker exec $(docker ps -qf "name=mysql") grep -- "-- " /var/lib/mysql/general.log | awk -F'\t' '{print $1}'
```

## 4.2 — Comparar los horarios

Los tres bloques de comandos anteriores te dan timestamps de cada evento. Con eso alcanza para reconstruir el orden: primero un uso normal de la app, después el pico de carga, después la fuerza bruta contra el login, y por último los intentos de inyección SQL — separados por segundos entre sí, pero perfectamente distinguibles.

## 4.3 — Por qué esto importa

Ninguna de las dos fuentes de log, por separado, cuenta la historia completa:

| Fuente | Qué muestra | Qué NO muestra |
|--------|-------------|------------------|
| Log de acceso de la app | Volumen, timing, ruta, código de estado | Contenido del formulario |
| `general_log` de MySQL | La consulta SQL exacta, incluida la inyectada | Nada sobre el tráfico HTTP en sí (headers, IP real, etc.) |

Investigar un incidente real casi siempre implica correlacionar **varias** fuentes de log, no una sola. Y todo lo que hicimos hoy fue manual, mirando archivos con `grep`/`awk` — no escala bien si tenés que revisar esto todos los días, o si la infraestructura crece a más de un servidor.

> En la próxima práctica vamos a automatizar esta parte: métricas y logs centralizados en tiempo real, con Prometheus y Grafana, en vez de archivos que hay que ir a buscar a mano.

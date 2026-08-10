# Paso 4 — La carga, ahora en vivo

En la práctica 1 medimos esta misma infraestructura con un loop de `curl`, leyendo los números al final de cada corrida. Ahora vamos a repetirlo mirando el dashboard de Grafana mientras corre.

## 4.1 — Dejar el dashboard a la vista

Volvé a la pestaña de Grafana con el dashboard del Paso 3. Arriba a la derecha, configurá el refresco automático (ícono con una flecha circular, al lado del selector de rango de tiempo) en **5s**, y el rango de tiempo en **Last 5 minutes**.

## 4.2 — Generar carga

En una terminal, ejecutá:

```bash
seq 1 2000 | xargs -P 50 -I{} curl -s -o /dev/null http://127.0.0.1:8888/
```

Mismos números que la práctica 1 (2000 peticiones, 50 en simultáneo), solo que acá con `curl` + `xargs` en vez de `ab`. Mientras corre (puede tardar uno o dos minutos), volvé a Grafana y mirá el panel "Requests por segundo": debería subir de golpe y mantenerse arriba mientras dura la carga, y volver a bajar cuando termina.

## 4.3 — Ver el impacto en MySQL

Mirá también el panel de conexiones a MySQL durante la misma carga — cada request a `/` dispara una consulta nueva, así que vas a ver el número de conexiones moverse en sincronía con el tráfico.

## 4.4 — Comparar con la práctica anterior

En `crud-logs-analisis-cli` tuviste que:

1. Terminar de generar/recibir la carga
2. Ir a buscar el archivo de log
3. Filtrarlo y contarlo con `grep`/`awk`
4. Recién ahí darte cuenta de que hubo un pico

Hoy viste el pico **mientras pasaba**, sin tocar un archivo. Esa es la diferencia entre investigar después de un incidente y monitorear en tiempo real — y por qué en un entorno productivo real se usan las dos cosas: métricas para detectar y alertar al instante, logs para investigar el detalle después.

## 4.5 — Un panel más: CPU de MySQL bajo carga

Si te sobra tiempo, agregá un tercer panel con esta consulta y repetí la carga mirándolo:

```
rate(container_cpu_usage_seconds_total{container_label_com_docker_compose_service="mysql"}[1m])
```

> Con esto cerramos el hilo conductor completo. Pasá a la reflexión final.

# Paso 2 — Levantando el stack de monitoreo

## 2.1 — Acceder a Prometheus

Hacé click en el ícono **hamburger** (≡) arriba a la derecha, seleccioná **"Traffic / Ports"**, escribí `9090` en **Custom Ports** y hacé click en **Access**.

## 2.2 — Revisar los targets

En el menú superior de Prometheus, andá a **Status → Targets** (o entrá directo a `/targets`). Deberías ver cuatro jobs, los cuatro en verde (`UP`):

| Job | A qué apunta |
|---|---|
| `prometheus` | El propio Prometheus |
| `cadvisor` | Métricas de todos los contenedores Docker |
| `mysql` | `mysqld-exporter`, que traduce el estado de MySQL a métricas |
| `crud-app` | El endpoint `/metrics` de nuestra app Flask |

Si alguno aparece en rojo (`DOWN`), esperá unos segundos y refrescá — puede que ese contenedor todavía esté arrancando.

## 2.3 — Tu primera consulta PromQL

Prometheus tiene su propio lenguaje de consultas, **PromQL**. En la pestaña **Graph** (o **Table**), probá:

```
up
```

Esto devuelve `1` para cada target que está respondiendo, y `0` para el que no. Es la consulta más simple posible, pero muy útil para un chequeo de salud general.

## 2.4 — Una métrica de MySQL

```
mysql_global_status_threads_connected
```

Te muestra cuántas conexiones activas tiene el servidor MySQL en este momento — la misma información que antes solo podías ver ejecutando una consulta manual.

## 2.5 — Una métrica de contenedores

```
rate(container_cpu_usage_seconds_total{container_label_com_docker_compose_service="mysql"}[1m])
```

Esto muestra el uso de CPU del contenedor de MySQL en el último minuto. El filtro `container_label_com_docker_compose_service` es una etiqueta que pone Docker Compose automáticamente — no depende del nombre exacto que le haya tocado al contenedor.

> Con Prometheus confirmando que junta las tres fuentes, pasá al Paso 3 para verlo todo junto en un dashboard de Grafana.

# ¡Escenario completado — y con él, el hilo conductor!

Armaste un stack de monitoreo real (Prometheus + Grafana + cAdvisor + mysqld-exporter) y viste, en vivo, el mismo tipo de carga que en la práctica 1 solo pudiste medir después de que terminaba.

## Lo que hiciste

- **Métricas vs. logs** — entendiste cuándo conviene cada enfoque
- **Prometheus** — verificaste que junta métricas de tres fuentes distintas: la app, MySQL y los contenedores
- **PromQL** — escribiste tus primeras consultas: `up`, `rate(...)`, filtros por etiqueta
- **Grafana** — conectaste una fuente de datos y armaste un dashboard con paneles propios
- **Observabilidad en tiempo real** — repetiste el stress test de la práctica 1 mirando el impacto mientras pasaba, no después

## Comandos y consultas clave para recordar

| Comando/Consulta | Para qué sirve |
|---|---|
| `curl http://<host>:8888/metrics` | Ver las métricas crudas que expone una app instrumentada |
| `up` | Chequeo de salud: qué targets está scrapeando Prometheus con éxito |
| `rate(<métrica>[1m])` | Tasa por segundo de una métrica acumulativa (contador), sobre una ventana de tiempo |
| `<métrica>{<etiqueta>="<valor>"}` | Filtrar una métrica por una etiqueta específica |

## Conceptos clave

**Métrica** — un número que cambia en el tiempo, pensado para ver tendencias y disparar alertas, no para reconstruir el detalle de un evento puntual.

**Scrape** — la forma en que Prometheus junta datos: va él a buscarlos a un endpoint HTTP, a intervalos regulares.

**Exporter** — un programa que traduce el estado interno de un sistema (MySQL, en este caso) al formato que Prometheus entiende.

**Dashboard** — un conjunto de paneles en Grafana, cada uno con su propia consulta PromQL.

## Todo el hilo conductor, de punta a punta

1. **`docker-mysql`** — desplegaste la infraestructura base a mano
2. **`crud-stress-test`** — la mediste con `curl`, y entendiste por qué el servidor de desarrollo de Flask no escala
3. **`crud-auth-login`** — le agregaste autenticación y sesiones
4. **`crud-ataques-red`** — la atacaste con reconocimiento, credenciales filtradas y fuerza bruta
5. **`crud-sqli`** — explotaste una inyección SQL real en el login, manual y con `sqlmap`
6. **`crud-logs-analisis-cli`** — investigaste la evidencia de todo lo anterior, a mano, con logs
7. **`crud-monitoreo-prometheus-grafana`** — instrumentaste la misma infraestructura para verla en tiempo real

La misma app, la misma base de datos, los mismos servicios — desplegados, medidos, protegidos, atacados, investigados y finalmente monitoreados. Ese es el ciclo de vida completo de un sistema en producción.

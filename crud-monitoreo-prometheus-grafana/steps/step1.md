# Paso 1 — Métricas vs. logs

## 1.1 — Dos formas distintas de observar un sistema

En la práctica anterior trabajamos con **logs**: eventos discretos, uno por línea, con todo el detalle de cada petición o consulta. Son ideales para investigar "qué pasó exactamente en este momento puntual", pero hay que ir a buscarlos, filtrarlos y leerlos.

Una **métrica** es distinta: es un número que cambia en el tiempo (cuántas peticiones por segundo, cuánta memoria usa un contenedor, cuántas conexiones tiene la base). No cuenta la historia completa de una petición individual, pero permite ver tendencias, picos y caídas de un vistazo — y alertar automáticamente cuando algo se sale de lo normal.

## 1.2 — ¿Qué es Prometheus?

**Prometheus** es un sistema que **recolecta métricas activamente**: cada pocos segundos, va a buscar ("scrapea") un endpoint HTTP en cada servicio que le interese, algo como:

```bash
curl -s http://127.0.0.1:8888/metrics | head -20
```

Ejecutá ese comando. Vas a ver texto plano con nombres de métrica y valores — eso es exactamente lo que Prometheus lee cada 5 segundos, según configuramos en `prometheus.yml`.

## 1.3 — ¿Qué es Grafana?

**Grafana** no recolecta nada por sí mismo: es una capa de visualización. Se conecta a una fuente de datos (en nuestro caso, Prometheus) y arma paneles y dashboards a partir de las métricas que esa fuente ya tiene guardadas.

## 1.4 — Qué vamos a monitorear hoy

| Componente | Qué expone | Quién lo junta |
|---|---|---|
| La app Flask | Peticiones por endpoint, latencia | Prometheus directo (`/metrics`) |
| MySQL | Conexiones, queries, estado del engine | `mysqld-exporter` |
| Los contenedores Docker | CPU, memoria, red por contenedor | `cAdvisor` |

> Con la idea general clara, pasá al Paso 2 para confirmar que Prometheus está juntando estas tres fuentes correctamente.

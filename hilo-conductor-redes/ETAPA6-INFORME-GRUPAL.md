# Cierre de la Etapa 6 — informe grupal

> Borrador de contenido. Falta pasarlo a presentación para estudiantes (mismo
> criterio que TRABAJO7-INSTRUCTIVO-DESPLIEGUE.md). Pensado como práctica de bajo
> riesgo de trabajo distribuido en Git, previa a la práctica de alto riesgo del
> Trabajo n°7 (ahí el equipo diseña de cero; acá explica algo que ya está armado).
>
> **Entrega:** un único `README.md` con una sección por parte, no archivos
> separados por integrante.

## Qué cambia respecto a la Etapa 6 actual

Redesplegar el stack y explicar el `docker-compose.yml` real que ya usaron
(`mysql`, `dbexporter`, `cadvisor`, `prometheus`, `grafana` — ver
`crud-monitoreo-prometheus-grafana/assets/setup.sh`) deja de ser un informe
individual y pasa a resolverse en equipo, con una parte de la explicación a cargo
de cada integrante. El objetivo pedagógico no cambia (Git, Markdown, sintaxis
YAML) — cambia que ahora el reparto del trabajo, y que quede evidenciado en el
historial de commits, es parte de lo que se evalúa.

## Cómo se reparte (grupo de 3)

El reparto de quién hace cada parte lo decide cada grupo — no lo asigna el
docente. Lo único fijo es que el archivo quede dividido en estas partes y que
cada una tenga un responsable claro en el historial de commits.

Cada parte incluye explicar qué hace cada servicio y la sintaxis YAML que aparece
en esa sección (tipos de dato, indentación, listas y mapas) — entre las tres
partes queda cubierto todo el archivo, sin que una sola persona explique el 100%.

**Parte 1 — Persistencia de datos:** `mysql` y `dbexporter`.
Por qué la contraseña de root se pasa por variable de entorno, para qué se monta
`my.cnf` como solo lectura (`:ro`) en `dbexporter`, y qué relación de dependencia
hay entre ambos servicios (`depends_on`).

**Parte 2 — Recolección de métricas:** `cadvisor` y `prometheus`.
Por qué `cadvisor` monta rutas del host en modo solo lectura, qué puerto de
`prometheus` se publica al host y por qué, y qué resuelve el `extra_hosts` con
`host.docker.internal` (la app Flask corre fuera de este `docker-compose`, en el
host — por eso Prometheus necesita ese puente para llegar a `/metrics`).

**Parte 3 — Visualización y la topología general:** `grafana`, y la red
`mynetwork` que conecta a los cinco servicios.
Por qué Grafana depende de Prometheus, para qué sirve la variable de entorno de
la contraseña de admin, y cómo la red común permite que cada servicio resuelva a
los demás por nombre (`dbexporter` se conecta a `mysql`, no a una IP).

**Grupos de otro tamaño:** con 2 integrantes, fusionar Parte 1 con Parte 2. Con 4,
separar `prometheus.yml` (el archivo de configuración de scraping, no el
`docker-compose.yml`) como una cuarta parte aparte, a cargo de quien haga la
introducción general.

## Qué queda compartido, no repartido

Alguien tiene que escribir la introducción del informe y la conclusión que une
las tres partes — no hace falta que sea siempre la misma persona a lo largo del
cuatrimestre, pero para este informe puede rotar o resolverse como texto conjunto
en una sola sesión.

## Evidencia en Git

- Cada integrante commitea su propia parte del informe, en commits separados de
  las de sus compañeros.
- Mensaje de commit que diga qué se explicó y por qué se lo entendió así — no
  "agrego parte 2 del informe".
- El commit de introducción/conclusión conjunta queda aparte, para que se note en
  el historial que es un aporte del equipo y no de una sola persona.

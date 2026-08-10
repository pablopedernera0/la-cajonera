# Cronograma — Hilo conductor de redes (Infraestructura de Redes, ITI 2°1°, 2do cuatrimestre 2026)

Cruce entre el hilo conductor de Killercoda y el programa de la materia. Las 6 etapas se ubican en semanas **virtuales** (acceso a computadora); las semanas **presenciales** son repaso conceptual con pizarrón/proyector, sin ejecutar nada.

**Versión comprimida:** las 6 etapas y el arranque del Trabajo n°7 entran en las primeras **4** semanas virtuales (18/ago a 29/sep), en vez de las 5 disponibles. Eso deja la 5ª semana virtual (13/oct) y su jueves (15/oct) completamente libres para ajustes y consultas — con Trabajo n°7 ya entregado antes, no para terminarlo ahí.

**Contrapartida de comprimir:** al pasar de 5 a 4 semanas para las etapas, se pierde el margen extra que tenía el cronograma original. Si alguna etapa se atrasa en clase (típicamente la 4, por `sqlmap`, o la 6, por la cantidad de contenedores), el margen sale de la clase de arranque del Trabajo n°7 (jueves 01/oct), no de las clases de ajuste que se están liberando. Vale la pena tenerlo presente al dar las clases, no hace falta decidir nada ahora.

## Semana Virtual 1 — 18/ago

| Día | Horario | Actividad |
|---|---|---|
| Martes 18/ago | 20:40–22:10 (90 min) | **Etapa 1** — `crud-stress-test` (45 min de práctica + repaso de throughput/latencia/concurrencia/procesos e hilos con la guía de estudiantes) |
| Jueves 20/ago | 19:20–20:40 (80 min) | **Etapa 2** — `crud-auth-login` (35 min de práctica + tiempo para dudas) |

## Semana Presencial — 25/ago y 27/ago
Repaso con pizarrón: diagramar autenticación/sesión, WSGI y el modelo de workers de Gunicorn sin computadora.

## Semana Virtual 2 — 01/sep

| Día | Horario | Actividad |
|---|---|---|
| Martes 01/sep | 20:40–22:10 | **Etapa 3** — `crud-ataques-red` (45 min, repetir la nota ética antes de empezar) |
| Jueves 03/sep | 19:20–20:40 | **Etapa 4** — `crud-sqli` (45 min, puede extenderse por `sqlmap` con time-based blind — la sesión completa de 80 min le da margen) |

## Semana Presencial — 08/sep y 10/sep
Repaso con pizarrón: diagramar la red (host vs. red interna de Docker), `nmap`/`hydra` conceptualmente, y la query vulnerable vs. la parametrizada.

## Semana Virtual 3 — 15/sep

| Día | Horario | Actividad |
|---|---|---|
| Martes 15/sep | 20:40–22:10 | **Etapa 5** — `crud-logs-analisis-cli` (40 min) |
| Jueves 17/sep | 19:20–20:40 | **Etapa 6, parte 1** — `crud-monitoreo-prometheus-grafana`: deploy + Prometheus (Pasos 1-2) |

## Semana Presencial — 22/sep y 24/sep
Demostración con proyector: dashboards de Grafana ya armados (el docente los muestra en vivo o con capturas).

## Semana Virtual 4 — 29/sep

| Día | Horario | Actividad |
|---|---|---|
| Martes 29/sep | 20:40–22:10 | **Etapa 6, parte 2** — Grafana (Paso 3) + stress test en vivo (Paso 4) + cierre del hilo conductor completo |
| Jueves 01/oct | 19:20–20:40 | **Arranque guiado del Trabajo n°7**: cada alumno redespliega rápido el stack de la Etapa 6 (el `setup.sh` tarda un par de minutos), hace `git init` y los primeros commits, y arma la estructura del `README.md` en clase |

## Semana Presencial — 06/oct y 08/oct
Consulta sobre el Trabajo n°7 sin computadora: repasar qué va en cada sección del README, dudas conceptuales de Git, mostrar ejemplos en el proyector.

**→ Entrega del Trabajo n°7: antes del martes 13/oct** (sugerido: domingo 11/oct o lunes 12/oct a la noche), para que las dos clases siguientes sean de ajuste, no de apuro.

## Semana Virtual 5 — 13/oct — Ajustes y consultas (sin contenido nuevo)

| Día | Horario | Actividad |
|---|---|---|
| Martes 13/oct | 20:40–22:10 | Consultas 1 a 1 sobre lo entregado: feedback puntual, corrección de detalles del repo/README, dudas técnicas de último momento |
| Jueves 15/oct | 19:20–20:40 | **Clase de repaso general** de las 6 etapas + preparación para el examen escrito del parcial |

## Parcial (presencial, en dos partes)

Fecha exacta a confirmar — la planilla todavía no tiene asignado el día puntual de Infraestructura de Redes para el parcial del 2do cuatrimestre (el bloque de "Parciales" arranca el 20/oct). Estructura sugerida, sea en una sesión o en dos:

**Parte A — Entrega y aprobación del Trabajo n°7.** No es una nueva entrega: es la instancia donde se revisa lo ya subido a GitHub, se le hacen un par de preguntas puntuales al alumno sobre decisiones que tomó (para confirmar autoría y comprensión), y se aprueba o se pide un ajuste menor.

**Parte B — Examen escrito, 10 preguntas.** Sobre el trabajo, el proceso (las 6 etapas) y los conceptos teóricos desarrollados en las guías de estudiantes (throughput/latencia/concurrencia, procesos e hilos, WSGI/Gunicorn, autenticación/sesiones, superficie de ataque, inyección SQL, métricas vs. logs, Prometheus/Grafana). Un buen banco de preguntas sale directo de las secciones "Qué debería mostrar el alumno" de la guía docente de cada etapa.

---

## Trabajo n°7 reformulado (con entrega flexible)

Reemplaza la consigna genérica actual (repo + README + docker-compose de 2 servicios de juguete) por una versión que documenta el hilo conductor real. El objetivo pedagógico del trabajo (Git, Markdown, YAML) no cambia — cambia el material sobre el que se aplica, y se ofrecen **dos formas de cumplirlo** para no dejar afuera a quien no llegue a levantar el stack completo por su cuenta.

**Título:** Documentación del proceso — hilo conductor de redes
**Nivel:** Intermedio

**Objetivo:** Aplicar un flujo de trabajo colaborativo con Git y documentar en Markdown el trabajo hecho a lo largo del hilo conductor (deploy, stress test, autenticación, ataques, SQLi, logs y monitoreo), explicando en profundidad al menos un archivo de configuración YAML real del proceso.

### Opción A — Repo técnico completo (recomendada si llegan a levantar el stack solos)

1. Redesplegar (o partir de lo hecho en la Etapa 6) el stack de `crud-monitoreo-prometheus-grafana`. Crear un repositorio con `git init`. Hacer al menos 4 commits describiendo el proceso. Crear una rama `feature/dashboard`, documentar en ella los paneles de Grafana armados (al menos 2 commits), y mergearla a `main`. Pushear a GitHub. Incluir la URL y una captura de `git log --oneline --graph`.
2. `README.md` con: título (H1) y descripción del stack; lista desordenada de tecnologías usadas (Prometheus, Grafana, cAdvisor, mysqld-exporter, Flask instrumentado); tabla con nombre/descripción/estado de al menos 4 archivos del repo; bloque de código con 3+ comandos comentados (PromQL, `ab`, etc.); un enlace externo y una imagen embebida (captura de un dashboard propio).
3. Explicar sección por sección la sintaxis YAML del `docker-compose.yml` real: tipos de datos, indentación, listas (`volumes`, `networks`) y mapas (`environment`). Señalar con comentarios qué línea define variables de entorno, mapeo de puertos, volumen montado y red personalizada.

**Entrega:** URL del repositorio + documento con capturas del proceso Git y de los dashboards.

### Opción B — Informe del proceso completo (alternativa flexible)

Para quien no llegue a levantar el stack de forma autónoma. Sigue exigiendo Git y Markdown reales, pero sobre el proceso de **las 6 etapas**, no solo la última.

1. Crear un repositorio con `git init`, con al menos 4 commits — uno por cada bloque de etapas que se documente (ej. "documento etapas 1-2", "documento etapas 3-4", etc.). Pushear a GitHub.
2. Un `informe.md` (o varios, uno por etapa, enlazados desde un índice) que recorra las 6 etapas del hilo conductor: qué se hizo en cada una, qué se aprendió, y al menos una captura o fragmento de salida real (el resultado de un `ab`, el volcado de `sqlmap`, un panel de Grafana, etc.) por etapa.
3. Tomar el `docker-compose.yml` real de la Etapa 6 (se puede copiar del `setup.sh` sin necesidad de tenerlo corriendo) y explicar su sintaxis YAML sección por sección, igual que en la Opción A, punto 3 — esta parte es la misma en las dos opciones, porque es la que cubre el objetivo de YAML del programa.

**Entrega:** URL del repositorio con el informe y el README explicando la estructura del repo.

**Modalidad:** Individual, en ambos casos.

> **Nota técnica pendiente:** el `docker-compose.yml` de la Etapa 6 hoy no tiene un volumen *nombrado* (solo un bind mount de `.my.cnf`). Si se quiere que el checklist quede 100% cubierto en la Opción A, conviene agregar `grafana-data:/var/lib/grafana` en el `setup.sh` de la Etapa 6, para que los dashboards sobrevivan a un restart — mejora real, no solo para cumplir la consigna. No lo toqué todavía.

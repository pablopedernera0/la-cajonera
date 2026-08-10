# Guía docente — Hilo conductor de redes

Esta guía es para el docente, no para el alumno. Cubre las **6 etapas del hilo conductor completo** que atraviesa la materia de redes: la misma infraestructura (MySQL + una app Flask CRUD, con Nginx/PhpMyAdmin en las primeras etapas) se despliega, se mide, se protege, se ataca, se investiga y finalmente se monitorea en vivo, a lo largo de seis prácticas encadenadas.

## Mapa del hilo conductor

| Orden | Escenario | Qué hace | Branch de la app |
|---|---|---|---|
| 0 | `docker-mysql` (ya existía) | Deploy manual de Nginx + MySQL + PhpMyAdmin + `crud-python` | `main` |
| 1 | `crud-stress-test` | Mide la infraestructura con `ab`, compara Flask dev server vs. Gunicorn | `main` |
| 2 | `crud-auth-login` | Agrega login + sesiones | `feature-login` |
| 3 | `crud-ataques-red` | Reconocimiento con `nmap`, credenciales hardcodeadas, fuerza bruta con `hydra` | `feature-login` |
| 4 | `crud-sqli` | Bypass manual y explotación automatizada con `sqlmap` de la inyección SQL en `/login` | `feature-login` |
| 5 | `crud-logs-analisis-cli` | Forense con `grep`/`awk` sobre logs de la app y `general_log` de MySQL | `feature-login` |
| 6 | `crud-monitoreo-prometheus-grafana` | Prometheus + Grafana + cAdvisor + mysqld-exporter, en vivo | `monitoring` |

**Importante:** cada escenario despliega su propia infraestructura desde cero (vía `setup.sh`) — no hace falta que el alumno haya completado literalmente el escenario anterior en la misma sesión de Killercoda para poder hacer el siguiente. Lo que sí importa es el orden narrativo/pedagógico: cada `finish.md` da por sentado que el alumno ya vio lo anterior. La etapa 5 además genera su propio tráfico de referencia (uso normal, pico de carga, fuerza bruta, SQLi) en el `setup.sh`, así que tampoco depende de que el alumno haya hecho las etapas 1-4 antes.

El código de la app vive fuera de este repo, en [`pablopedernera0/crud-python`](https://github.com/pablopedernera0/crud-python): branch `feature-login` (login vulnerable, usada en las etapas 2 a 5) y branch `monitoring` (métricas Prometheus vía `prometheus_flask_exporter`, usada en la etapa 6, basada en `main` — sin login, para poder pegarle `ab` directo). La vulnerabilidad de SQLi está documentada en ese repo, no en el de Killercoda.

## Nota ética (repetir en clase antes de las etapas 3 y 4)

Las etapas 3 y 4 usan herramientas de ataque reales (`nmap`, `hydra`, `sqlmap`) contra infraestructura real, aunque esté dentro de un sandbox descartable. Vale la pena remarcar explícitamente:

- Todo el ataque es contra **infraestructura propia, desplegada por el alumno, dentro de su propio sandbox**.
- Las mismas técnicas contra un sistema ajeno, sin autorización explícita, son un delito.
- El objetivo pedagógico es que entiendan cómo piensa un atacante para poder defender mejor — no formar atacantes.

## Logística general

- **Duración total de las 6 etapas:** 45 + 35 + 45 + 45 + 40 + 45 = **255 minutos** (~4 horas 15). No entra en pocas clases; conviene repartirlo en varios encuentros virtuales.
- **Cronograma real (Infraestructura de Redes, ITI 2°1°, 2do cuatrimestre 2026):** ver [`CRONOGRAMA-HILO-REDES-2C-2026.md`](./CRONOGRAMA-HILO-REDES-2C-2026.md) — versión comprimida: las 6 etapas y el arranque del Trabajo n°7 entran en 4 semanas virtuales (18/ago a 29/sep), dejando la 5ª semana virtual (13/oct) y su jueves (15/oct) libres para ajustes y consultas, con el Trabajo n°7 ya entregado antes. Incluye también la estructura del parcial (entrega/aprobación + examen escrito) y el Trabajo n°7 reformulado con dos opciones de entrega (repo técnico completo o informe del proceso, para no dejar afuera a quien no llegue a levantar el stack solo).
- **Regla general para reprogramar en otros cuatrimestres/comisiones:** killercoda va siempre en clases virtuales (acceso a computadora); las presenciales son para demostración y repaso conceptual.
- **Verificar antes de la clase:** el plan de Killercoda utilizado y el tiempo de sandbox disponible por sesión — las etapas 3, 4 y 6 en particular pueden extenderse (`sqlmap` con *time-based blind*, o levantar 5 contenedores de monitoreo).
- Todas las etapas usan las mismas credenciales base, lo que ayuda a que el alumno no tenga que volver a aprenderlas: MySQL root `mysecretpassword`, usuario de la app `admin` / `admin123`.

## Etapa 1 — `crud-stress-test` (45 min)

📄 [Guía docente](https://github.com/pablopedernera0/pablopedernera0.github.io/blob/master/hilo-conductor-redes/documentacion/crud-stress-test-guia-docente.md) · [Guía para estudiantes](https://github.com/pablopedernera0/pablopedernera0.github.io/blob/master/hilo-conductor-redes/documentacion/crud-stress-test-guia-estudiantes.md) — throughput, latencia, concurrencia, tasa de error, `ab` y Gunicorn explicados en profundidad.

**Objetivos de aprendizaje:**
- Explicar qué miden throughput, latencia, concurrencia y tasa de error
- Usar `ab` contra un endpoint de lectura y uno de escritura, e interpretar la salida
- Explicar por qué el servidor de desarrollo de Flask (single-threaded) se degrada bajo concurrencia
- Levantar la misma app con Gunicorn y comparar métricas

**Qué debería poder mostrar/explicar el alumno al final:**
- El resultado de `ab -n 500 -c 20` contra `GET /` (throughput alto, `Failed requests: 0`)
- Que el mismo test contra `POST /nuevo` da menos throughput que el de lectura
- Un resultado con `Failed requests > 0` al forzar `-c 200` contra el puerto 8888 (Flask dev server)
- El mismo test contra el puerto 8889 (Gunicorn, 4 workers) con throughput sensiblemente mayor y menos (o cero) fallos

**Resultados esperados (referencia rápida para corregir):**
- Base de datos sembrada con 5 alumnos
- `ps aux | grep app.py` → un único proceso Python en el puerto 8888
- `ps aux | grep gunicorn` → un proceso master + 4 workers en el puerto 8889

**Riesgo/ética:** ninguno — no hay ataques en esta etapa.

## Etapa 2 — `crud-auth-login` (35 min)

**Objetivos de aprendizaje:**
- Diferenciar autenticación de autorización
- Explicar qué es una sesión y por qué HTTP la necesita (protocolo sin estado)
- Leer un `@app.before_request` y entender cómo protege rutas sin tocarlas una por una

**Qué debería poder mostrar/explicar el alumno al final:**
- `curl -sI http://127.0.0.1:8888/` sin cookie → `302` a `/login`
- Login exitoso con `admin` / `admin123`, tanto desde el navegador como con `curl -c`/`-b`
- Identificar en el código que la password se guarda en texto plano en la tabla `usuarios`

**Resultados esperados:** usuario sembrado único: `admin` / `admin123`.

**Riesgo/ética:** ninguno particular — esta etapa solo deja la vulnerabilidad instalada, no la explota ni la menciona explícitamente. Evitar spoilear las etapas 3 y 4 si un alumno pregunta "¿esto no es inseguro?" — la respuesta corta es "vamos a verlo pronto", no explicar el bypass acá.

## Etapa 3 — `crud-ataques-red` (45 min)

**Objetivos de aprendizaje:**
- Diferenciar superficie de ataque externa (publicada al host) de interna (solo dentro de la red Docker)
- Encontrar credenciales hardcodeadas en código fuente y entender su impacto
- Ejecutar un ataque de fuerza bruta con `hydra` contra un formulario web (`http-post-form`)

**Qué debería poder mostrar/explicar el alumno al final:**
- `nmap -sV -p 80,8080,8888 localhost` con los tres servicios identificados
- `nmap -p 3306 localhost` → cerrado/sin respuesta, pero abierto al escanear la IP interna del contenedor MySQL
- Conexión directa a MySQL con `root` / `mysecretpassword` (encontrada en `app.py`)
- Resultado de `hydra` con la línea `login: admin   password: admin123`

**Resultados esperados (referencia rápida):**
- Puertos publicados: `80` (nginx), `8080` (nginx sirviendo PhpMyAdmin), `8888` (Werkzeug/Flask)
- `3306` cerrado desde `localhost`, abierto desde la IP interna de Docker
- `hydra` encuentra `admin123` contra `/login` (wordlist de ejemplo de 7 entradas, con `admin123` incluida)

**Riesgo/ética:** repetir la nota ética general. Además: remarcar por qué se ataca `/login` propio y no PhpMyAdmin (token anti-CSRF) — es un buen punto para preguntar "¿cómo se defiende esto en la vida real?".

## Etapa 4 — `crud-sqli` (45 min, puede extenderse)

**Objetivos de aprendizaje:**
- Explicar la diferencia entre una consulta parametrizada y una armada por concatenación/f-string
- Ejecutar un bypass manual de autenticación por SQLi
- Usar `sqlmap` para detectar y explotar automáticamente una inyección, y volcar una tabla

**Qué debería poder mostrar/explicar el alumno al final:**
- `curl --data-urlencode "usuario=admin' -- "` → `302` (bypass exitoso) vs. una password cualquiera → `200`
- La variante `' OR '1'='1' -- ` funcionando igual, sin conocer el nombre `admin`
- `sqlmap -p usuario --batch` detectando el parámetro como inyectable
- `sqlmap ... --dump -D alumnos -T usuarios` con el volcado completo de la tabla

**Resultados esperados (referencia rápida — validado en un entorno real, no solo en teoría):**
```
Database: alumnos
Table: usuarios
+----+---------+----------+
| id | usuario | password |
+----+---------+----------+
| 1  | admin   | admin123 |
| 2  | soporte | sopor23! |
+----+---------+----------+
```

**Nota de timing:** en la corrida de validación, `sqlmap` detectó la inyección por **time-based blind** (no boolean-based) — cada carácter extraído implica varias peticiones con `SLEEP`, y el `--dump` completo tardó **~3-4 minutos**. Avisar a los alumnos que es esperable que el comando "tarde en volver", para que no lo corten pensando que se colgó.

**Riesgo/ética:** repetir la nota ética general. Cerrar mostrando el fix real (una línea: parametrizar la query) para que la clase no termine con "esto queda roto para siempre" sino con "así se arregla".

## Etapa 5 — `crud-logs-analisis-cli` (40 min)

**Objetivos de aprendizaje:**
- Leer logs de acceso de una app (formato Werkzeug) y encontrar patrones agrupando por timestamp
- Distinguir un pico de carga y una fuerza bruta solo por volumen y agrupamiento temporal
- Habilitar y leer el `general_log` de MySQL — la única fuente que expone el contenido exacto de una consulta SQL
- Correlacionar dos fuentes de log distintas para armar una línea de tiempo

**Qué debería poder mostrar/explicar el alumno al final:**
- `grep '"GET / ' app.log | awk -F'[][]' '{print $2}' | sort | uniq -c | sort -rn` mostrando el pico de carga (60 en el mismo segundo)
- `grep '"POST /login' app.log | awk '{print $9}' | sort | uniq -c` mostrando el patrón de fuerza bruta (10 fallidos / 4 exitosos)
- `docker exec <mysql> grep -- "-- " /var/lib/mysql/general.log` mostrando el texto exacto de la inyección SQL

**Resultados esperados (referencia rápida — validado en un entorno real):** el `setup.sh` de esta etapa genera su propio tráfico (uso normal + pico de 60 requests concurrentes + 10 intentos de fuerza bruta + 3 payloads de SQLi), así que el alumno no depende de las etapas anteriores. Con eso, `grep -- "-- "` sobre el `general_log` debería encontrar exactamente dos líneas: `usuario = 'admin' -- '...` y `usuario = '' OR '1'='1' -- '...`.

**Riesgo/ética:** ninguno — es un escenario defensivo/forense, no genera ataques nuevos.

## Etapa 6 — `crud-monitoreo-prometheus-grafana` (45 min, puede extenderse)

**Objetivos de aprendizaje:**
- Diferenciar métricas (series numéricas) de logs (eventos)
- Entender el modelo de "scrape" de Prometheus
- Escribir consultas PromQL básicas (`up`, `rate(...)`, filtros por etiqueta)
- Conectar Grafana a Prometheus y armar un dashboard propio
- Observar en vivo el mismo stress test de la etapa 1

**Qué debería poder mostrar/explicar el alumno al final:**
- Los 4 targets de Prometheus (`prometheus`, `cadvisor`, `mysql`, `crud-app`) en verde (`UP`) en `/targets`
- Un dashboard de Grafana con al menos 2 paneles propios (requests/segundo de la app, conexiones de MySQL)
- El panel de requests/segundo subiendo en vivo mientras corre `ab -n 2000 -c 50` contra el puerto 8888

**Riesgo/ética:** ninguno — cierra el hilo con el enfoque proactivo, sin ataques.

**Nota de infraestructura:** esta etapa dropea PhpMyAdmin y Nginx (no aportan al monitoreo) y usa la branch `monitoring` de `crud-python` (sin login, basada en `main`), para poder pegarle `ab` directo al endpoint `/` como en la etapa 1. La app sigue corriendo en el host (no dockerizada); Prometheus la alcanza vía `host.docker.internal:8888`.

## Notas técnicas para quien mantenga estos escenarios (no para dar en clase)

- Todos los `setup.sh` usan `docker exec -i <container> mysql ... << 'EOSQL'` — la flag `-i` es obligatoria; sin ella el heredoc no llega al contenedor y la tabla no se crea, en silencio. `cloud-storage-101/assets/setup.sh` (escenario más viejo) tiene este mismo bug sin corregir.
- Las seis etapas clonan `crud-python`; las etapas 2-5 usan la branch `feature-login`, las etapas 1 y 6 usan `main`/`monitoring` respectivamente (sin login).
- **En la etapa 6:** el servicio del exporter de MySQL no puede llamarse `mysqld-exporter` en el `docker-compose.yml` — `docker ps -qf "name=mysql"` lo matchea también por substring y `docker exec` puede terminar apuntando al contenedor equivocado. Se llama `dbexporter`. Además, `prom/mysqld-exporter:latest` (v0.19.0+) ya no soporta `DATA_SOURCE_NAME` por variable de entorno — necesita un `.my.cnf` montado y `--config.my-cnf=/.my.cnf`.
- Contraseñas/credenciales de referencia usadas en todo el hilo: MySQL `root`/`mysecretpassword`; app `admin`/`admin123` (y `soporte`/`sopor23!`, sembrado solo en `crud-sqli` para que el `--dump` muestre más de una fila).

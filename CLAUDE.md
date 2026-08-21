# La Cajonera

Repositorio de escenarios Killercoda para las materias que dicta Pablo Pedernera en el
Terciario Urquiza (Rosario). Cada carpeta de primer nivel es un escenario independiente,
servido tal cual por Killercoda — por eso ningún escenario se anida dentro de otra carpeta.

El repo está linkeado a la cuenta de Killercoda `pablop22` — cada push a `main` actualiza la
plataforma automáticamente, sin publicación manual. Link directo a un escenario para dar a
los alumnos: `https://killercoda.com/pablop22/scenario/<carpeta>` (patrón verificado
contra la plataforma real, no asumido).

Este archivo existe para que cualquier sesión de Claude Code, en cualquier computadora,
pueda retomar el trabajo sin depender de la memoria de una conversación anterior — Pablo
trabaja desde dos máquinas distintas con instalaciones locales separadas, así que lo único
que viaja entre ellas es lo que está commiteado acá.

---

## Hilo conductor de redes (Infraestructura de Redes, ITI)

El proyecto activo principal: 6 escenarios encadenados sobre la misma infraestructura
(MySQL + una app Flask CRUD), que se despliega, mide, protege, ataca, investiga y
monitorea.

> ⚠️ **Incidente 2026-08-10: cuenta de Killercoda bloqueada, después desbloqueada con
> condición.** Corriendo `ab` (Etapa 1) la cuenta `pablop22` quedó baneada por "illegal
> activity... cryptominers, security scanners, bruteforce or hacker-tools". Las etapas 3 y 4
> **instalan `nmap`, `hydra` y `sqlmap`** — las categorías que el mensaje prohíbe por nombre —
> así que se sacaron de este repo (que está linkeado a Killercoda) como precaución. El mismo
> día, `security@killercoda.com` desbloqueó la cuenta pero confirmó por escrito que
> **prohíben esas categorías de herramienta sin importar la intensidad de uso** ("not
> possible for us to differentiate between legitimate and malicious usage"). Eso confirmó
> que la Etapa 1 (`ab`) necesitaba el mismo tratamiento aunque se usara con carga liviana —
> no alcanza con moderarla, hay que sacarla igual.
>
> Todo lo movido está en
> [`pablopedernera0/hilo-conductor-redes-ataques`](https://github.com/pablopedernera0/hilo-conductor-redes-ataques)
> (público): entorno `docker-compose` para que el alumno lo clone
> y lo corra en su propia máquina, sin Killercoda de por medio. La Etapa 1 se dividió en dos
> en vez de moverse entera: una versión **liviana** se quedó acá (`crud-stress-test/`, mide
> con un loop de `curl` en vez de `ab`) para que quien no tiene PC propia siga la práctica en
> Killercoda, y una versión **realista** (`ab` real, carga hasta romper la app) se sumó al
> repo aparte para quien sí tiene PC — el docente muestra esa corrida real en vivo desde su
> computadora. Ya se respondió el mail de Killercoda confirmando que se tomó nota de la
> restricción (enviado 2026-08-10). **No reagregues las etapas 3/4 (nmap/hydra/sqlmap) a
> `la-cajonera`.**

| Etapa | Carpeta | Qué hace | Branch de `crud-python` | Estado |
|---|---|---|---|---|
| 0 (previa) | `docker-mysql` | Deploy manual de la infraestructura base | `main` | En Killercoda |
| 1 | `crud-stress-test` | Medición de carga (versión liviana con `curl`), Flask dev server vs. Gunicorn | `main` | En Killercoda — versión liviana. Versión realista con `ab` real en `hilo-conductor-redes-ataques/crud-stress-test` |
| 2 | `crud-auth-login` | Login + sesiones (vulnerabilidad SQLi instalada, no explotada) | `feature-login` | En Killercoda |
| 3 | `crud-ataques-red` | Reconocimiento con `nmap`, credenciales hardcodeadas, `hydra` | `feature-login` | **Pausada, movida a `hilo-conductor-redes-ataques`** |
| 4 | `crud-sqli` | Bypass manual + `sqlmap` sobre la inyección de la etapa 2 | `feature-login` | **Pausada, movida a `hilo-conductor-redes-ataques`** |
| 5 | `crud-logs-analisis-cli` | Forense con `grep`/`awk` sobre logs + `general_log` de MySQL | `feature-login` | En Killercoda — depende narrativamente de 3/4 pero no técnicamente (genera su propio tráfico) |
| 6 | `crud-monitoreo-prometheus-grafana` | Prometheus + Grafana + cAdvisor + mysqld-exporter | `monitoring` | En Killercoda |

El código de la app vive en [`pablopedernera0/crud-python`](https://github.com/pablopedernera0/crud-python)
— nunca en este repo. Cada `setup.sh` clona la branch que corresponde.

**Documentación del hilo conductor:** todo en `hilo-conductor-redes/`:
- `GUIA-DOCENTE-HILO-REDES.md` — objetivos, evaluación y logística por etapa
- `CRONOGRAMA-HILO-REDES-2C-2026.md` — cruce con el programa oficial y el cronograma real de clases (comisión ITI 2°1°, 2C 2026), incluye el Trabajo n°7 reformulado
- Versión publicada (HTML + desarrollo de contenidos por etapa, para docente y para estudiantes) en el repo `pablopedernera0.github.io`, carpeta `hilo-conductor-redes/`

**Estado (actualizado 2026-08-11): la migración de las etapas 3/4 a `hilo-conductor-redes-ataques`
quedó completa y confirmada end-to-end.** Se adaptaron `crud-ataques-red/steps/*.md` y
`crud-sqli/steps/*.md` de formato Killercoda a "tu propia terminal contra `docker-compose`",
se sacaron los artefactos de Killercoda que quedaron sin uso (`index.json`,
`assets/setup.sh`) y se agregó un servicio `toolbox` (nmap/hydra/sqlmap dockerizados, para
no pedirle a cada alumno que instale herramientas distintas según su SO). Pablo recorrió las
**6 etapas completas del hilo conductor de punta a punta como lo haría un alumno**
(Killercoda + terminal local) y quedaron confirmadas sin excepciones pendientes. Detalle
completo (hallazgos, bugs corregidos, topología real) en
`hilo-conductor-redes-ataques/NOTAS-DOCENTE.md`.

---

## Convenciones al escribir un escenario nuevo

- Estructura: `index.json`, `intro.md`, `steps/stepN.md` (subcarpeta `steps/`, no archivos
  sueltos numerados), `finish.md`, `assets/setup.sh`. Mirar `cloud-storage-101/` como
  plantilla — es más nueva que `docker-mysql/`, que usa la convención vieja de
  `` `comando`{{exec}} `` inline (no replicar esa).
- Comandos en bloques ` ```bash ` normales, sin `{{exec}}`.
- `setup.sh`: banner con colores (`banner()`, `ok()`, `warn()`), pasos numerados `[n/N]`,
  `set -e`, espera con loop + timeout para servicios, resumen final con puertos/servicios.
- La imagen `ubuntu` de Killercoda ya trae Docker — nunca instalar `docker.io`, solo
  `docker-compose` si hace falta.
- **`docker exec <container> mysql ... << 'EOSQL'` necesita `-i`.** Sin esa flag el heredoc
  no llega al contenedor y falla en silencio (exit 0, sin crear nada). Bug real, ya
  corregido en las 6 etapas del hilo conductor. `cloud-storage-101/assets/setup.sh` (más
  viejo) todavía lo tiene sin corregir.
- Si un servicio de `docker-compose` puede colisionar por nombre con un filtro
  `docker ps -qf "name=mysql"` (ej. un exporter llamado `mysqld-exporter`), renombrarlo
  para evitar el falso positivo — pasó en la etapa 6, el exporter se llama `dbexporter`.
- `prom/mysqld-exporter:latest` (v0.19+) no soporta `DATA_SOURCE_NAME` por variable de
  entorno — necesita un `.my.cnf` montado y `--config.my-cnf=/.my.cnf`.
- **Antes de dar un escenario por terminado, probar el `setup.sh` real contra Docker local**
  (hay Docker disponible en este entorno de desarrollo), no alcanza con `bash -n` y
  `python3 -m json.tool`. Varios bugs reales de los de arriba solo aparecieron corriendo
  el script completo, no leyendo el código.

---

## Otros escenarios del repo

Carpetas preexistentes, sin relación con el hilo conductor: `docker`, `docker-interfaces`,
`docker-mongodb`, `docker-mysql`, `gitflow`, `linux-basico`, `markdown`, `mermaid`,
`stack-redes-tcp-ip-build`, `stack-redes-tcp-ip-trouble`, `cloud-storage-101`. No tocar
salvo pedido explícito.

---

## Repos relacionados (mismo docente, otras materias/propósitos)

- `pablopedernera0.github.io` — sitio de recursos públicos para alumnos. Convención: una
  carpeta por tema con su propio `index.html` autocontenido; no siempre enlazada desde la
  portada. Ahí vive también la versión publicada de la guía docente del hilo conductor.
- `sistema-eidas` (`~/trabajos/pablo/terciario-urquiza/sistema-eidas`) — sistema de
  evaluación asistida por IA para Diseño de Sistemas Web (AF), no relacionado con Killercoda.
  Tiene su propio `CLAUDE.md` con el mismo espíritu que este archivo.
- `hilo-conductor-redes-ataques` (público) — etapas 1
  (`crud-stress-test`, versión realista con `ab`), 3 y 4 del hilo conductor, sacadas de acá
  por el incidente de Killercoda (ver arriba). Entorno `docker-compose` que el alumno clona
  y corre en su propia máquina. Tiene su propio `CLAUDE.md` y un `NOTAS-DOCENTE.md` con el
  detalle completo del incidente y el estado pendiente.
- `alternativas-claude-code` (público) — infraestructura Docker Compose (Ollama+Aider,
  OpenCode, Gemini CLI, GitHub Copilot CLI) para que los alumnos prueben alternativas
  gratuitas a Claude Code en su propia máquina. Acompaña a la página
  `pablopedernera0.github.io/alternativas-claude-code/`, que documenta hallazgos reales de
  probar cada herramienta (no solo lo que dice cada documentación oficial) — ver el `README.md`
  de ese repo para el detalle de bugs encontrados (Ollama necesita `OLLAMA_HOST=0.0.0.0`
  explícito, `@github/copilot` pide Node 22+, etc.). No relacionado con el hilo conductor de
  redes ni con Killercoda.

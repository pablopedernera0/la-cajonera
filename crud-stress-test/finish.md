# ¡Escenario completado!

Mediste con carga liviana la infraestructura CRUD (Flask + MySQL) que desplegaste en la práctica anterior, y entendiste por qué el servidor de desarrollo de Flask no aguanta tráfico real.

## Lo que hiciste

- **Conceptos de stress testing** — throughput, latencia, concurrencia y tasa de error
- **Loop de `curl` + `xargs`** — generaste carga liviana contra un endpoint de lectura (`GET /`) y uno de escritura (`POST /nuevo`)
- **Comparación lectura vs. escritura** — confirmaste que escribir en la base es más costoso que leer
- **Servidor de desarrollo single-threaded** — leyendo código y procesos, entendiste por qué `app.run()` no escala bajo concurrencia real (esa carga real no se puede generar en esta plataforma — tu docente te la mostró aparte)
- **Gunicorn** — levantaste la misma app con 4 workers en paralelo y repetiste la carga liviana

## Comandos clave para recordar

| Comando | Para qué sirve |
|---------|----------------|
| `seq 1 N \| xargs -P C -I{} curl ...` | Generar carga liviana contra un endpoint, con hasta `C` peticiones en simultáneo |
| `time ( ... )` | Medir cuánto tardó un bloque de comandos, para calcular throughput aproximado |
| `gunicorn -w <workers> -b <host:puerto> <módulo>:<app>` | Levantar una app Flask con un servidor de producción |
| `ps aux \| grep <proceso>` | Ver cuántos procesos están atendiendo peticiones |

## Conceptos clave

**Throughput** — peticiones por segundo que el servidor logra atender.

**Latencia** — tiempo que tarda en resolverse una petición individual.

**Concurrencia** — cantidad de peticiones simultáneas.

**Servidor de desarrollo vs. servidor de producción** — `app.run()` (Werkzeug) atiende una petición a la vez; Gunicorn (u otro servidor WSGI) reparte la carga entre varios workers.

## Próximo paso

En el siguiente escenario vamos a **atacar** esta misma infraestructura: reconocimiento con `nmap`, la password de MySQL que quedó hardcodeada en el código fuente, y fuerza bruta contra PhpMyAdmin. Vas a ver que los mismos servicios que hoy mediste son los que hay que asegurar.

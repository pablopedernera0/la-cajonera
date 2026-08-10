# ¡Escenario completado!

Sometiste a carga la infraestructura CRUD (Flask + MySQL) que desplegaste en la práctica anterior y encontraste su límite real.

## Lo que hiciste

- **Conceptos de stress testing** — throughput, latencia, concurrencia y tasa de error
- **Apache Bench** — generaste carga contra un endpoint de lectura (`GET /`) y uno de escritura (`POST /nuevo`)
- **Comparación lectura vs. escritura** — confirmaste que escribir en la base es más costoso que leer
- **Límite del servidor de desarrollo** — llevaste el servidor de desarrollo de Flask (single-threaded) a fallar bajo concurrencia
- **Gunicorn** — levantaste la misma app con 4 workers en paralelo y repetiste la prueba que había roto la app

## Comandos clave para recordar

| Comando | Para qué sirve |
|---------|----------------|
| `ab -n <peticiones> -c <concurrencia> <url>` | Generar carga contra un endpoint GET |
| `ab -n <peticiones> -c <concurrencia> -p <archivo> -T <content-type> <url>` | Generar carga contra un endpoint POST |
| `gunicorn -w <workers> -b <host:puerto> <módulo>:<app>` | Levantar una app Flask con un servidor de producción |
| `ps aux \| grep <proceso>` | Ver cuántos procesos están atendiendo peticiones |

## Conceptos clave

**Throughput** — peticiones por segundo que el servidor logra atender.

**Latencia** — tiempo que tarda en resolverse una petición individual.

**Concurrencia** — cantidad de peticiones simultáneas.

**Servidor de desarrollo vs. servidor de producción** — `app.run()` (Werkzeug) atiende una petición a la vez; Gunicorn (u otro servidor WSGI) reparte la carga entre varios workers.

## Próximo paso

En el siguiente escenario vamos a **atacar** esta misma infraestructura: reconocimiento con `nmap`, la password de MySQL que quedó hardcodeada en el código fuente, y fuerza bruta contra PhpMyAdmin. Vas a ver que los mismos servicios que hoy mediste con `ab` son los que hay que asegurar.

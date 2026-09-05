# ¡Escenario completado!

Mediste con carga liviana la infraestructura CRUD (Flask + MySQL) que desplegaste en la práctica anterior, entendiste por qué el servidor de desarrollo de Flask no aguanta tráfico real, y aprendiste a calcular cuánta capacidad hace falta antes de necesitarla.

## Lo que hiciste

- **Conceptos de stress testing** — throughput, latencia, concurrencia y tasa de error
- **Loop de `curl` + `xargs`** — generaste carga liviana contra un endpoint de lectura (`GET /`) y uno de escritura (`POST /nuevo`)
- **Comparación lectura vs. escritura** — confirmaste que escribir en la base es más costoso que leer
- **Servidor de desarrollo single-threaded** — leyendo código y procesos, entendiste por qué `app.run()` no escala bajo concurrencia real (esa carga real no se puede generar en esta plataforma — tu docente te la mostró aparte)
- **Gunicorn** — levantaste la misma app con 4 workers en paralelo y repetiste la carga liviana
- **Casos reales de dimensionamiento** — healthcare.gov, Pokémon GO, Shopify y Ticketmaster: qué pasa cuando el cálculo de capacidad se hace mal, o no se hace
- **Dimensionamiento propio** — calculaste cuántos workers necesita tu infraestructura para sostener un pico de tráfico con margen de seguridad, y lo verificaste

## Comandos clave para recordar

| Comando | Para qué sirve |
|---------|----------------|
| `seq 1 N \| xargs -P C -I{} curl ...` | Generar carga liviana contra un endpoint, con hasta `C` peticiones en simultáneo |
| `time ( ... )` | Medir cuánto tardó un bloque de comandos, para calcular throughput aproximado |
| `gunicorn -w <workers> -b <host:puerto> <módulo>:<app>` | Levantar una app Flask con un servidor de producción |
| `ps aux \| grep <proceso>` | Ver cuántos procesos están atendiendo peticiones |
| `techo( objetivo × margen / capacidad_por_worker )` | Calcular cuántos workers necesitás para un pico de tráfico dado |

## Conceptos clave

**Throughput** — peticiones por segundo que el servidor logra atender.

**Latencia** — tiempo que tarda en resolverse una petición individual.

**Concurrencia** — cantidad de peticiones simultáneas.

**Servidor de desarrollo vs. servidor de producción** — `app.run()` (Werkzeug) atiende una petición a la vez; Gunicorn (u otro servidor WSGI) reparte la carga entre varios workers.

**Dimensionamiento** — calcular cuánta capacidad hace falta para un tráfico esperado, con margen de seguridad, antes de necesitarla. El mismo cálculo que le faltó a healthcare.gov y le sobró a Shopify.

## 📮 Antes de seguir: mini-reporte de la etapa

Mandanos un mensaje corto (mail al docente o la plataforma de la materia) con:

1. La salida de `ps aux | grep app.py` corriendo la app en modo desarrollo — mostrando que es un único proceso.
2. En 2-3 líneas: ¿por qué `app.run()` (el servidor de desarrollo de Flask) no escala bajo carga concurrente, aunque el código no tenga ningún error? ¿Qué cambia al levantar la misma app con Gunicorn?
3. Tus tres números del Paso 7: `T_normal`, `capacidad_por_worker` y `workers_necesarios`, con la cuenta hecha.
4. En 2-3 líneas: de los casos del Paso 6, ¿cuál se parece más a lo que hiciste vos en el Paso 7, y por qué?

No suma nota — es un checkpoint para confirmar que la etapa quedó entendida antes de pasar a la siguiente.

## Próximo paso

En el siguiente escenario vamos a **atacar** esta misma infraestructura: reconocimiento con `nmap`, la password de MySQL que quedó hardcodeada en el código fuente, y fuerza bruta contra PhpMyAdmin. Vas a ver que los mismos servicios que hoy mediste son los que hay que asegurar.

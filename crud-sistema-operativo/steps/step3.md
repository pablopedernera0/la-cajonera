# Paso 3 — Hilos: MySQL por dentro

Un **hilo** (*thread*) es una línea de ejecución **dentro** de un proceso. Un proceso puede tener muchos hilos: todos comparten la misma memoria y los mismos archivos abiertos, pero cada uno avanza por su cuenta, y el kernel los reparte entre los núcleos de CPU como si fueran procesos separados.

Gunicorn resuelve la concurrencia con **varios procesos**. MySQL la resuelve con **un solo proceso y muchos hilos**. Vamos a verlo.

## 3.1 — Un solo proceso

```bash
pgrep -x mysqld
ps -o pid,stat,rss,cmd -p $(pgrep -x mysqld)
```

Hay **un** proceso `mysqld`. Desde el host lo ves como un proceso más, aunque corra dentro de un contenedor (esto lo retomamos en el Paso 5).

## 3.2 — Sus hilos

`ps -T` muestra los hilos de un proceso. La columna `SPID` es el identificador de cada hilo:

```bash
ps -T -p $(pgrep -x mysqld) | head -15
```

Los hilos de MySQL tienen nombre, y el nombre dice a qué se dedica cada uno:

| Nombre del hilo | Qué hace |
|---|---|
| `ib_io_rd-*`, `ib_io_wr-*` | Lectura y escritura a disco del motor InnoDB |
| `ib_pg_flush_co` | Baja a disco las páginas de datos modificadas en memoria |
| `ib_log_writer` | Escribe el registro de transacciones (*redo log*) |
| `sig_handler` | Atiende las **señales** que el kernel le entrega al proceso (por ejemplo, la orden de apagarse) |
| `connection` | Atiende a **una** conexión de cliente |

Contalos:

```bash
grep Threads /proc/$(pgrep -x mysqld)/status
```

Anotá el número: en la prueba de esta guía, MySQL arrancó con unos 40 hilos.

## 3.3 — Un hilo por conexión

El script `abrir_conexiones.sh` abre 10 conexiones a MySQL que quedan esperando 60 segundos (`SELECT SLEEP(60)`) y después se cierran solas:

```bash
abrir_conexiones.sh 10
sleep 3
grep Threads /proc/$(pgrep -x mysqld)/status
```

El número subió. MySQL usa por defecto el modelo **un hilo por conexión**: cada cliente conectado tiene un hilo dedicado dentro de `mysqld`.

Preguntale a MySQL qué ve él del mismo fenómeno:

```bash
docker exec mysql mysql -uroot -pmysecretpassword -e "SHOW GLOBAL STATUS LIKE 'Threads_%';" 2>/dev/null
```

| Variable | Significado |
|---|---|
| `Threads_connected` | Conexiones abiertas ahora (tus 10 + la de esta consulta) |
| `Threads_running` | Hilos ejecutando algo en este momento |
| `Threads_created` | Hilos que MySQL tuvo que **crear** desde que arrancó |
| `Threads_cached` | Hilos que quedaron libres y se guardan para reusarlos |

> **Nota:** es posible que la cantidad de hilos no haya subido exactamente 10. Cuando una conexión se cierra, MySQL no destruye el hilo: lo guarda en un *thread cache* (hasta 9, por defecto) para reusarlo en la próxima conexión, porque crear un hilo cuesta tiempo. Como en el Paso 2 la carga HTTP abrió y cerró cientos de conexiones, ya había hilos guardados para reusar.

Esperá a que pase el minuto y volvé a mirar: las conexiones se cierran, `Threads_connected` baja, y `Threads_cached` sube.

```bash
sleep 60
docker exec mysql mysql -uroot -pmysecretpassword -e "SHOW GLOBAL STATUS LIKE 'Threads_%';" 2>/dev/null
```

## 3.4 — ¿Procesos o hilos?

Ahora tenés los dos modelos de concurrencia funcionando en la misma máquina:

| | Gunicorn (procesos) | MySQL (hilos) |
|---|---|---|
| Unidad de trabajo | **Procesos** worker: cada uno atiende una petición a la vez | Un **hilo** por conexión |
| Memoria | Cada worker tiene su propia memoria | Todos los hilos comparten la memoria del proceso |
| Si uno falla | El master lo reemplaza y los demás siguen | Un error grave en un hilo puede tirar abajo todo `mysqld` |
| Compartir datos | Difícil: hay que pasarlos entre procesos | Fácil: está todo en la misma memoria (y por eso hacen falta *locks*) |
| Costo de crear uno | Más alto (`fork`) | Más bajo, pero no gratis (por eso el *thread cache*) |

> **Conexión con el hilo conductor:** en la etapa 1 calculamos cuántos workers necesitaba la app. Ese número es una decisión de sistema operativo: cada worker es un proceso que ocupa memoria y compite por CPU. En Python hay un motivo extra para usar procesos en vez de hilos: el *GIL* del intérprete no deja que dos hilos ejecuten código Python al mismo tiempo en el mismo proceso.

> Si viste subir la cantidad de hilos de `mysqld` al abrir conexiones, estás listo para continuar.

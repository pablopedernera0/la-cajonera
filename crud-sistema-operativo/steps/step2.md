# Paso 2 — Procesos: Gunicorn por dentro

Un **proceso** es un programa en ejecución: el código, más la memoria, los archivos abiertos y el estado que el kernel lleva de él. Cada proceso tiene un **PID** y un **padre** (PPID), el proceso que lo creó.

En la etapa 1 del hilo conductor pasamos del servidor de desarrollo de Flask (un solo proceso) a **Gunicorn con varios workers**. Ahora vamos a ver qué significa eso para el sistema operativo.

## 2.1 — El árbol de procesos

```bash
pstree -p $(pgrep -o gunicorn)
```

`pgrep -o gunicorn` devuelve el PID del proceso `gunicorn` más viejo (el master). Vas a ver algo así (los números van a ser otros):

```
gunicorn(1208)-+-gunicorn(1213)
               |-gunicorn(1214)
               `-{gunicorn}(1215)
```

| Qué ves | Qué es |
|---|---|
| `gunicorn(1208)` | El proceso **master**: no atiende peticiones, supervisa a los workers |
| `gunicorn(1213)`, `gunicorn(1214)` | Los 2 **workers**, procesos hijos del master. Son los que atienden a la app |
| `{gunicorn}(1215)` | Entre llaves: no es un proceso sino un **hilo** del master. Lo vemos en el Paso 3 |

Los workers nacen con **`fork()`**, la llamada al sistema con la que un proceso se duplica: el hijo arranca como una copia exacta del padre (mismo código, misma memoria) y a partir de ahí sigue su propio camino.

## 2.2 — Mirar los procesos con `ps`

```bash
ps -o pid,ppid,stat,rss,cmd -p $(pgrep -d, gunicorn)
```

| Columna | Significado |
|---|---|
| `PID` | Identificador del proceso |
| `PPID` | PID del padre. Los dos workers tienen como padre al master |
| `STAT` | Estado: `S` = dormido esperando algo, `R` = corriendo o listo para correr, `l` = tiene varios hilos |
| `RSS` | Memoria RAM real que ocupa, en KB (más sobre esto en el Paso 4) |
| `CMD` | El comando con el que se lanzó |

Casi seguro vas a ver todos en `S`: sin tráfico, los workers están **bloqueados** esperando que llegue una conexión. Un proceso dormido no consume CPU.

## 2.3 — Lo que el kernel sabe de un proceso

Toda esa información sale de `/proc/<PID>/`. Mirá la del master:

```bash
grep -E '^(Name|State|Pid|PPid|Threads|VmRSS)' /proc/$(pgrep -o gunicorn)/status
```

## 2.4 — Los procesos bajo carga

Lanzá tráfico contra la app en segundo plano (`&`), mandando su salida a un archivo para que no se mezcle, y abrí `top` enseguida:

```bash
carga_http.sh 1000 10 > /tmp/carga.log &
top
```

Mientras dura la carga (unos 20 segundos), mirá en `top` las filas de `gunicorn`: los workers pasan a estado `R` y a usar CPU, y también aparece `mysqld`. Tocá `q` para salir de `top` y después:

```bash
cat /tmp/carga.log
```

> **Nota:** fijate en la línea `%Cpu(s)` de arriba de `top`: `us` es tiempo de CPU en modo usuario (la app, Python, MySQL) y `sy` es tiempo en modo kernel (las llamadas al sistema del Paso 1).

## 2.5 — Matar a un worker

Elegí uno de los workers y terminalo con la señal `SIGTERM` (el `kill` por defecto):

```bash
WORKER=$(pgrep -P $(pgrep -o gunicorn) | head -1)
echo "Voy a terminar el worker $WORKER"
kill $WORKER
sleep 2
pstree -p $(pgrep -o gunicorn)
```

El worker que mataste ya no está, pero hay **otro con un PID nuevo**. El master detectó que uno de sus hijos murió y creó otro con un nuevo `fork()`. Lo confirma el log de Gunicorn:

```bash
tail -3 /root/crud-python/gunicorn.log
```

```
[INFO] Worker exiting (pid: 1213)
[INFO] Booting worker with pid: 1324
```

> **Por qué importa:** esto es lo que el servidor de desarrollo de Flask no podía hacer. Con un solo proceso, si ese proceso muere, la app se cae. Con un master y varios workers, la muerte de uno es un evento que el sistema resuelve solo, y los demás siguen atendiendo mientras tanto.

> Si viste un worker con un PID nuevo en el árbol, estás listo para continuar.

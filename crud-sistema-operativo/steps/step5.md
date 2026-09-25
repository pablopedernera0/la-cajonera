# Paso 5 — Un contenedor es un proceso con anteojeras

Suele decirse que Docker "virtualiza". Es cierto a medias, y en este paso vamos a ver por qué. En el Paso 1 viste (probablemente) que esta máquina es una **máquina virtual**: un hipervisor le simula hardware, y arriba corre un kernel Linux completo. Un contenedor **no** hace eso.

Un contenedor es un **proceso común del host** al que el kernel le pone dos cosas:

- **Namespaces**: limitan lo que el proceso **ve** (sus propios PIDs, su propia red, su propio sistema de archivos, su propio nombre de máquina).
- **cgroups**: limitan y cuentan lo que el proceso **usa** (CPU, memoria, disco, cantidad de procesos).

## 5.1 — El mismo kernel

```bash
uname -r
docker exec mysql uname -r
```

Es exactamente la misma versión. El contenedor no tiene kernel propio: MySQL le hace sus llamadas al sistema al mismo kernel que atiende a tu `bash`.

## 5.2 — El mismo proceso, visto desde los dos lados

Desde el host, `mysqld` es un proceso con un PID cualquiera:

```bash
pgrep -x mysqld
docker top mysql
```

Desde adentro del contenedor, ese mismo proceso es el **PID 1**, el primero del sistema:

```bash
docker exec mysql cat /proc/1/comm
```

Es el mismo proceso con dos números distintos. Eso es el **namespace de PID**: el contenedor tiene su propia numeración, y adentro no puede ver ningún proceso del host.

## 5.3 — Los namespaces, uno por uno

Cada proceso tiene en `/proc/<PID>/ns/` un enlace por cada namespace al que pertenece. Si dos procesos muestran el mismo número, comparten ese namespace. Comparemos `mysqld` con el PID 1 del host:

```bash
M=$(pgrep -x mysqld)
for ns in pid net mnt uts user; do
  printf "%-5s  host: %-22s  mysql: %s\n" $ns $(readlink /proc/1/ns/$ns) $(readlink /proc/$M/ns/$ns)
done
```

| Namespace | Qué aísla | ¿Distinto? |
|---|---|---|
| `pid` | La numeración de procesos | Sí: por eso `mysqld` es PID 1 adentro |
| `net` | Interfaces de red, IPs, puertos | Sí: por eso el contenedor tiene su propia IP en la red de Docker |
| `mnt` | El sistema de archivos visible | Sí: adentro ve la imagen de MySQL, no el disco del host |
| `uts` | El nombre de la máquina | Sí: compará `hostname` con `docker exec mysql cat /etc/hostname` |
| `user` | Los usuarios y sus UID | **No**: Docker, por defecto, comparte el namespace de usuarios con el host |

Ese último detalle tiene una consecuencia visible:

```bash
ps -o user,uid,pid,cmd -p $(pgrep -x mysqld)
```

Adentro del contenedor, MySQL corre como el usuario `mysql`, con UID 999. Pero para el kernel un usuario es solo un número. Desde el host, `ps` busca quién es el 999 **en el host**, y muestra ese nombre (o el número pelado, si en el host no existe ese usuario). Por eso **root dentro de un contenedor es, por defecto, el mismo UID 0 que root del host**, con anteojeras y algunos permisos recortados: si las anteojeras fallan, el proceso queda con poder de root real.

## 5.4 — cgroups: lo que el kernel cuenta de cada contenedor

`ver_cgroup.sh` busca el cgroup del contenedor y muestra algunos de sus archivos:

```bash
ver_cgroup.sh mysql
```

| Archivo | Qué contiene |
|---|---|
| `cpu.stat` → `usage_usec` | Microsegundos de CPU que usaron **todos** los procesos e hilos del contenedor desde que arrancó |
| `cpu.stat` → `user_usec` / `system_usec` | Lo mismo, separado en modo usuario y modo kernel (Paso 1) |
| `cpu.max` | El límite de CPU. `max 100000` significa "sin límite" |
| `memory.current` | Bytes de memoria en uso. De acá sale el número de `docker stats` del Paso 4 |
| `memory.max` | El límite de memoria (`max` = sin límite). En `probar_oom.sh` valía 32 MB |

Mirá la línea `Cgroup:`: es una ruta del tipo `/sys/fs/cgroup/system.slice/docker-<id>.scope`. Esa es la ruta que el kernel usa para agrupar los procesos del contenedor.

## 5.5 — Es el mismo número que muestra Prometheus

En la etapa 6 del hilo conductor, cAdvisor identificaba a cada contenedor solo por un `id` con la forma `/system.slice/docker-<id>.scope`, sin nombre. Ahora sabés por qué: **cAdvisor lee los cgroups del kernel**, y ese `id` es la ruta del cgroup.

Abrí Prometheus en el puerto **9090** (en Killercoda, menú **Traffic / Ports**) y andá a la página **Query**: ahí vas a pegar una consulta y verla en la pestaña **Table** (el valor actual) o **Graph** (el gráfico en el tiempo). Pedile al script que te la arme con el ID real del contenedor:

```bash
consulta_cpu_mysql.sh
```

El script te da dos consultas. Para este punto usá la primera (el **contador crudo**), ejecutala en la pestaña **Table** y comparala con `usage_usec` (volvé a correr `ver_cgroup.sh mysql`):

| Fuente | Valor en la prueba de esta guía |
|---|---|
| `usage_usec` en `cpu.stat` | `31149468` microsegundos |
| `container_cpu_usage_seconds_total` en Prometheus | `31.128` segundos |

Es el mismo dato: Prometheus lo muestra en segundos, y va unos segundos atrasado porque lo lee cada 5 segundos. Todo el recorrido cAdvisor → Prometheus → Grafana arranca en un archivo de texto del kernel.

> Si encontraste el mismo número en `cpu.stat` y en Prometheus, estás listo para continuar.

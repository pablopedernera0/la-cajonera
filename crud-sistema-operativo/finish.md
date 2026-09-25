# ¡Escenario completado!

## Lo que hiciste

- Viste que un programa no toca el hardware: le **pide** todo al kernel con **llamadas al sistema**, y una sola petición HTTP son cientos de ellas.
- Recorriste el árbol de **procesos** de Gunicorn, mataste un worker y viste al master reemplazarlo con un `fork()` nuevo.
- Contaste los **hilos** de MySQL y viste que cada conexión tiene el suyo, con un *thread cache* para no crearlos de cero cada vez.
- Distinguiste la **memoria virtual** de un proceso de la **memoria real** que ocupa, y provocaste un **OOM kill** (código 137).
- Comprobaste que un contenedor es un **proceso del host** con **namespaces** (lo que ve) y **cgroups** (lo que usa), sobre el **mismo kernel**.
- Encontraste en un archivo del kernel (`cpu.stat`) el mismo número que Prometheus muestra como CPU del contenedor.
- Limitaste la CPU de MySQL y mediste el ***throttling*** del scheduler: el mismo trabajo tardó el doble.

## Comandos clave para recordar

| Comando | Para qué |
|---|---|
| `uname -r` | Versión del kernel |
| `strace -c <programa>` | Contar las llamadas al sistema que hace un programa |
| `pstree -p <pid>` | Árbol de procesos e hilos |
| `ps -o pid,ppid,stat,rss,cmd -p <pid>` | Estado, padre y memoria de un proceso |
| `ps -T -p <pid>` | Hilos de un proceso |
| `cat /proc/<pid>/status` | Todo lo que el kernel sabe de un proceso |
| `free -h` | Memoria de la máquina (mirar `available`) |
| `top -H -p <pid>` | CPU por hilo, en vivo |
| `docker top <contenedor>` | Procesos de un contenedor, con PIDs del host |
| `readlink /proc/<pid>/ns/<tipo>` | A qué namespace pertenece un proceso |
| `cat /proc/<pid>/cgroup` | En qué cgroup está un proceso |
| `docker update --cpus 0.5 <contenedor>` | Limitar la CPU de un contenedor en caliente |

## Conceptos clave

- **Kernel:** núcleo del sistema operativo. Es el único con acceso directo al hardware; administra procesos, memoria, archivos y red.
- **Modo usuario / modo kernel:** los programas corren con permisos limitados y pasan a modo kernel solo a través de una llamada al sistema.
- **Llamada al sistema (syscall):** pedido de un programa al kernel (`openat`, `read`, `write`, `fork`, `mmap`, `connect`...).
- **Proceso:** programa en ejecución, con memoria propia y un PID. Se crea con `fork()`.
- **Hilo:** línea de ejecución dentro de un proceso. Los hilos de un mismo proceso comparten la memoria.
- **Memoria virtual:** cada proceso tiene su propio espacio de direcciones; el kernel y la MMU lo traducen a páginas de RAM física.
- **OOM killer:** mecanismo del kernel que termina un proceso cuando no hay memoria para darle.
- **Scheduler:** parte del kernel que reparte el tiempo de CPU entre los hilos listos para correr.
- **Namespace:** aislamiento de lo que un proceso ve (PIDs, red, archivos, nombre de máquina, usuarios).
- **cgroup:** agrupación de procesos para limitar y contar recursos (CPU, memoria, E/S).
- **Contenedor:** proceso (o grupo de procesos) con namespaces y cgroups propios, sobre el kernel del host. No es una máquina virtual.

## Para pensar

1. ¿Por qué Gunicorn usa procesos para atender más tráfico y MySQL usa hilos? ¿Qué gana y qué arriesga cada uno?
2. `mysqld` tenía unos 3 GB de memoria virtual y menos de 500 MB reales. ¿Cómo puede ser?
3. Un contenedor muere una y otra vez con código 137. ¿Por dónde empezarías a buscar?
4. ¿Por qué cAdvisor puede medir la CPU de un contenedor sin preguntarle nada a Docker ni a MySQL?
5. Una app en un contenedor responde lento, pero en `top` la máquina tiene CPU libre. ¿Qué contador del cgroup mirarías, y por qué?

## Próximo paso

Todo lo que viste acá estuvo funcionando en cada etapa del hilo conductor, desde el primer `docker run` de MySQL. La próxima vez que midas una app, que mires un gráfico de CPU o que un contenedor se reinicie solo, ya sabés qué está haciendo el sistema operativo por debajo.

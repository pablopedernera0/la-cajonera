# Paso 1 — El kernel y las llamadas al sistema

El sistema operativo tiene un núcleo, el **kernel**: el único programa que puede tocar el hardware de forma directa (CPU, memoria, disco, placa de red). Todo lo demás (`bash`, `curl`, Python, MySQL, Docker) corre en **modo usuario** y, cuando necesita algo del hardware, se lo **pide** al kernel.

## 1.1 — ¿Sobre qué estás parado?

```bash
uname -r
uname -m
nproc
free -h
```

| Comando | Qué te dice |
|---|---|
| `uname -r` | La versión del kernel Linux que está corriendo |
| `uname -m` | La arquitectura del procesador (`x86_64` = 64 bits de Intel/AMD) |
| `nproc` | Cuántos núcleos de CPU puede usar el sistema |
| `free -h` | Cuánta memoria RAM hay y cuánta está en uso |

Ahora fijate si esta máquina es física o virtual:

```bash
systemd-detect-virt
lscpu | grep -i hypervisor
```

Si `systemd-detect-virt` responde algo como `kvm`, `qemu` o `vmware` (en vez de `none`), estás adentro de una **máquina virtual**: un **hipervisor** le presenta a este Linux un hardware simulado. Guardá ese dato: en el Paso 5 lo vamos a comparar con lo que hace Docker.

## 1.2 — `/proc`: la ventana al kernel

Linux expone lo que sabe el kernel como si fueran archivos, dentro de `/proc`. No están en ningún disco: el kernel los genera en el momento en que los leés.

```bash
cat /proc/loadavg
head -5 /proc/meminfo
ls /proc | head -20
```

Los nombres que son números son **procesos**: cada número es un PID (identificador de proceso), y dentro de cada carpeta está todo lo que el kernel sabe de ese proceso. Vamos a usar estas carpetas en todos los pasos que siguen.

## 1.3 — Llamadas al sistema: cuando un programa le pide algo al kernel

`strace` muestra cada **llamada al sistema** (*syscall*) que hace un programa. Probalo con el programa más simple que se te ocurra:

```bash
strace -e trace=openat,read,write,close cat /etc/hostname
```

Buscá estas líneas cerca del final (el nombre de la máquina va a ser otro):

```
openat(AT_FDCWD, "/etc/hostname", O_RDONLY) = 3
read(3, "1128768a9e42\n", 131072)       = 13
write(1, "1128768a9e42\n", 13)          = 13
close(3)                                = 0
```

| Llamada | Qué le pidió `cat` al kernel |
|---|---|
| `openat(...) = 3` | "Abrime este archivo." El kernel responde con un **descriptor de archivo**, un número (3) para referirse a él |
| `read(3, ...)` | "Dame el contenido del descriptor 3." |
| `write(1, ...)` | "Escribí esto en el descriptor 1", que es la **salida estándar** (tu terminal) |
| `close(3)` | "Ya terminé con ese archivo." |

`cat` no sabe leer un disco ni dibujar en una pantalla. Solo sabe pedirle esas cosas al kernel.

## 1.4 — ¿Cuántas llamadas hace una petición HTTP?

Ahora con algo más parecido a lo que hicimos todo el cuatrimestre: un `curl` a la app.

```bash
strace -c -f curl -s -o /dev/null http://127.0.0.1:8888/
```

`-c` no muestra cada llamada: las cuenta y al final muestra un resumen por tipo. Mirá la última línea (`total`): para una sola petición HTTP, `curl` hizo **cientos** de llamadas al sistema (en la prueba de esta guía fueron unas 450).

Algunas que vas a reconocer:

| Syscall | Para qué la usa `curl` |
|---|---|
| `mmap`, `brk` | Pedir memoria |
| `openat`, `read` | Leer bibliotecas y archivos de configuración (por ejemplo, `/etc/hosts`) |
| `socket`, `connect` | Abrir la conexión TCP al puerto 8888 |
| `sendto`, `recvfrom` | Mandar el `GET /` y recibir la respuesta |

> **Conexión con el hilo conductor:** cada vez que corrimos `seq 1 2000 | xargs curl ...` en la etapa 1, el kernel atendió cientos de miles de llamadas como estas. Parte de la CPU que se "gasta" bajo carga es tiempo de kernel (`sy` en `top`), no de la app.

> Si viste el resumen de `strace -c` con su línea `total`, estás listo para continuar.

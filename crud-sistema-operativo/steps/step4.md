# Paso 4 — Memoria: virtual, real y el OOM killer

El kernel no le da a cada proceso un pedazo de la RAM física sin más. Le da un **espacio de direcciones virtual** propio: cada proceso cree que tiene toda la memoria para él, y el kernel, con ayuda del hardware (la **MMU** del procesador), traduce esas direcciones virtuales a direcciones reales de RAM, de a bloques llamados **páginas** (normalmente de 4 KB).

Dos consecuencias prácticas:

- Un proceso **no puede** leer la memoria de otro: sus direcciones apuntan a páginas distintas.
- Un proceso puede **reservar** mucha más memoria de la que realmente usa. Las páginas se asignan en RAM recién cuando se tocan por primera vez.

## 4.1 — La memoria de la máquina

```bash
free -h
```

| Columna | Significado |
|---|---|
| `total` | RAM física total |
| `used` | En uso por los procesos |
| `free` | Totalmente sin usar |
| `buff/cache` | Usada por el kernel como caché de disco: archivos leídos hace poco quedan en RAM por si se vuelven a pedir |
| `available` | Lo que realmente hay disponible para un proceso nuevo: la memoria libre más la caché que el kernel puede soltar |

> **Nota:** que `free` sea bajo no es un problema. Linux usa la RAM libre como caché porque la RAM sin usar es RAM desperdiciada. El número que importa es `available`.

## 4.2 — Memoria virtual vs. memoria real de MySQL

```bash
grep -E '^(VmSize|VmRSS)' /proc/$(pgrep -x mysqld)/status
```

| Campo | Qué mide |
|---|---|
| `VmSize` | Tamaño del espacio de direcciones **virtual** del proceso: todo lo que reservó |
| `VmRSS` | *Resident Set Size*: lo que realmente está ocupando páginas de **RAM física** |

En la prueba de esta guía, `mysqld` tenía unos **3 GB** de memoria virtual y menos de **500 MB** reales. La diferencia es memoria reservada que nunca se tocó (o que el kernel mandó a *swap*).

Para ver cómo está armado ese espacio virtual:

```bash
pmap $(pgrep -x mysqld) | tail -5
```

Cada línea es una región del espacio de direcciones: bibliotecas compartidas, la pila de cada hilo, y bloques `[ anon ]` (memoria pedida al kernel con `mmap`, la syscall más usada por `curl` en el Paso 1).

## 4.3 — Memoria por contenedor

```bash
docker stats --no-stream
```

La columna `MEM USAGE / LIMIT` muestra cuánto usa cada contenedor y cuál es su límite. Si no le pusiste límite, el "límite" es toda la RAM de la máquina.

¿De dónde saca Docker ese número? No se lo pregunta a MySQL: se lo pregunta al **kernel**. Lo vemos en el Paso 5.

## 4.4 — Cuando la memoria se termina: el OOM killer

¿Qué pasa si un proceso pide más memoria de la que se le permite? El kernel tiene un mecanismo de último recurso: el **OOM killer** (*Out Of Memory*), que elige un proceso y lo termina a la fuerza.

`probar_oom.sh` arranca un contenedor chico con un límite de **32 MB** y un proceso que pide memoria sin parar:

```bash
probar_oom.sh
```

```
El proceso terminó con código de salida: 137
¿Lo mató el OOM killer? true
```

El proceso no terminó por un error propio: lo terminó el kernel con la señal `SIGKILL` (número 9). Por convención, un proceso que muere por una señal devuelve `128 + número de señal` = `137`.

> **Para recordar:** un contenedor que se reinicia solo y devuelve `137` casi siempre es un problema de memoria, no de código. Es uno de los errores más comunes al poner una app en producción con límites de memoria mal calculados.

> Si viste el código de salida 137, estás listo para continuar.

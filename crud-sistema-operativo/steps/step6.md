# Paso 6 — El scheduler y los límites de CPU

En la máquina hay muchos más hilos listos para trabajar que núcleos de CPU. El **scheduler** (planificador) del kernel decide, miles de veces por segundo, qué hilo corre en qué núcleo y durante cuánto tiempo. Cuando un hilo usa su porción de tiempo, el kernel lo saca del núcleo y pone a otro: eso es un **cambio de contexto**.

Los cgroups le agregan una regla más al scheduler: "este grupo de procesos, como mucho, puede usar tanta CPU". Vamos a ponerle esa regla a MySQL y medir el efecto.

## 6.1 — La medición de base, sin límite

`carga_cpu_mysql.sh` le pide a MySQL un trabajo de CPU **fijo** (calcular 5 millones de hashes SHA2) y mide cuánto tarda:

```bash
carga_cpu_mysql.sh
```

Anotá el tiempo. En la prueba de esta guía fueron **2.5 segundos**; en Killercoda puede ser distinto, según la máquina que te toque.

Ese trabajo lo hace **un solo hilo** de `mysqld` (una conexión = un hilo, Paso 3). Para verlo, repetí la carga en segundo plano y mirá los hilos con `top -H`:

```bash
carga_cpu_mysql.sh 3 > /dev/null &
top -H -p $(pgrep -x mysqld)
```

Un hilo `connection` aparece cerca del **100 %**, es decir, un núcleo entero, y los demás hilos de MySQL casi en 0. Un solo hilo no puede usar más de un núcleo a la vez. Tocá `q` para salir.

## 6.2 — Ponerle un límite a MySQL

```bash
docker update --cpus 0.5 mysql
ver_cgroup.sh mysql
```

Mirá `cpu.max`: ahora dice `50000 100000`. Es la forma en que el kernel expresa "medio núcleo":

| Valor | Significado |
|---|---|
| `100000` | El **período**: 100 000 microsegundos = 100 ms |
| `50000` | La **cuota**: dentro de cada período de 100 ms, el grupo puede usar como mucho 50 ms de CPU |

Cuando el cgroup gasta su cuota antes de que termine el período, el scheduler **deja de darle CPU** hasta el período siguiente, aunque haya núcleos libres. Eso se llama ***throttling***.

## 6.3 — El mismo trabajo, con límite

```bash
carga_cpu_mysql.sh
```

Mismo trabajo, **más o menos el doble de tiempo**. En la prueba de esta guía: de 2.5 a 5.9 segundos. El trabajo no cambió; lo que cambió es cuánta CPU le dejó usar el scheduler.

Ahora mirá los contadores de throttling:

```bash
ver_cgroup.sh mysql | grep -E 'nr_periods|nr_throttled|throttled_usec'
```

| Contador | Significado |
|---|---|
| `nr_periods` | Períodos de 100 ms en los que el grupo quiso usar CPU |
| `nr_throttled` | En cuántos de esos períodos se quedó sin cuota y tuvo que esperar |
| `throttled_usec` | Tiempo total que pasó frenado, en microsegundos |

## 6.4 — Verlo en Prometheus

Volvé a la página **Query** de Prometheus y pegá la **segunda** consulta que te da el script (la que empieza con `irate(`), en la pestaña **Graph**, con rango de **5m**:

```bash
consulta_cpu_mysql.sh
```

Ahora corré una carga un poco más larga, **con** el límite puesto:

```bash
carga_cpu_mysql.sh 3
```

Esperá unos 15 segundos (para que las dos corridas no se peguen en el gráfico). Después sacale el límite (`--cpu-quota -1` es la forma de decirle "sin cuota") y corré la misma carga:

```bash
docker update --cpu-quota -1 mysql
ver_cgroup.sh mysql | grep -A1 cpu.max
carga_cpu_mysql.sh 3
```

Volvé al gráfico y refrescalo. Vas a ver dos "montañas":

| Corrida | Forma en el gráfico |
|---|---|
| Con `--cpus 0.5` | Baja y ancha: ronda **0.5** núcleos y dura más |
| Sin límite | Alta y angosta: llega cerca de **1** núcleo y termina antes |

El área debajo de las dos es más o menos la misma, porque el trabajo total fue el mismo.

> **Nota:** en la etapa 6 usamos `rate()`, que promedia toda la ventana. Acá usamos `irate()`, que calcula la velocidad con las **dos últimas** lecturas: es más nerviosa, pero no aplana un pico corto como este. Prometheus lee el contador cada 5 segundos, así que el gráfico tiene esa resolución.

> **Conexión con el hilo conductor:** en la etapa 1 dimensionamos cuántos workers necesitaba la app para una carga dada. En un entorno real con contenedores, esa cuenta también tiene que incluir los límites de CPU de cada contenedor: un servicio "lento" puede no tener ningún problema de código, sino estar siendo frenado por el scheduler. `nr_throttled` es la primera métrica que hay que mirar en ese caso.

> Si viste que el mismo trabajo tarda más con el límite puesto, completaste la práctica. Pasá a la reflexión final.

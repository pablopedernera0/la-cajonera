# Paso 7 — Dimensioná tu propia infraestructura

Ahora te toca a vos hacer el cálculo que le faltó a healthcare.gov y le sobró a Shopify: cuántos workers de Gunicorn necesitás para sostener un pico de tráfico, calculado con margen, **antes** de necesitarlo.

Todos los números de este paso salen de tu propia sesión — no hay una respuesta "correcta" fija, porque depende de cuánto rinde el contenedor donde estás corriendo esto.

## 7.1 — Tu punto de partida: el tráfico normal

Ya lo mediste en el Paso 2: el tiempo que tardaron 50 peticiones con 5 en simultáneo contra `GET /`. Si guardaste `tiempo-lectura.txt`, recuperalo:

```bash
cat /root/tiempo-lectura.txt 2>/dev/null || cat tiempo-lectura.txt
```

Calculá el throughput de ese momento (peticiones ÷ segundos). Ese número es tu **tráfico normal** — lo vas a llamar `T_normal`.

## 7.2 — El objetivo: el pico de inscripción

La secretaría de la escuela te avisa que, durante la semana de inscripción, el sistema de alumnos recibe **4 veces** el tráfico de un día normal — y, después de escuchar cómo le fue a Niantic con Pokémon GO (Paso 6.2), pide dejar un **margen de seguridad del 30%** por si el número termina siendo mayor.

```
objetivo_pico = T_normal × 4
objetivo_con_margen = objetivo_pico × 1.3
```

## 7.3 — Medí cuánto aguanta un solo worker

Necesitás un número propio de referencia: cuántas peticiones por segundo sostiene **un** worker de Gunicorn en tu contenedor. Levantalo solo, en otro puerto:

```bash
cd /root/crud-python
nohup gunicorn -w 1 -b 0.0.0.0:8890 app:app > /root/crud-python/gunicorn-1w.log 2>&1 &
sleep 2
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8890/
```

Empujalo con más concurrencia que en los pasos anteriores, para tener un número más representativo:

```bash
time ( seq 1 200 | xargs -P 20 -I{} curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8890/ | sort | uniq -c )
```

Calculá el throughput (200 ÷ segundos) — ese es tu `capacidad_por_worker`.

> Igual que en el Paso 3: esto es una aproximación optimista, no una prueba de estrés real. Esta plataforma no te deja llevar el worker a su límite real (esa herramienta está prohibida acá, ver la intro), así que el número que te da es más alto de lo que ese worker aguantaría bajo una carga sostenida de verdad. Para este ejercicio alcanza — lo importante es el método de cálculo, no la precisión del número.

## 7.4 — Calculá cuántos workers necesitás

La fórmula de dimensionamiento es la misma que usa cualquier equipo de infraestructura, con distintos nombres:

```
workers_necesarios = techo( objetivo_con_margen / capacidad_por_worker )
```

Hacé la cuenta con tus propios números de 7.1 y 7.3. Redondeá siempre **hacia arriba** — un worker de más sobra, uno de menos falta.

## 7.5 — Levantá la infraestructura dimensionada

Con el número que calculaste (reemplazá `N` por tu resultado):

```bash
cd /root/crud-python
nohup gunicorn -w N -b 0.0.0.0:8891 app:app > /root/crud-python/gunicorn-dimensionado.log 2>&1 &
sleep 2
ps aux | grep gunicorn | grep -v grep
```

Deberías ver `N` workers más el proceso master.

## 7.6 — Confirmá que la infraestructura dimensionada responde

```bash
time ( seq 1 100 | xargs -P 20 -I{} curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8891/ | sort | uniq -c )
```

Si ves `100 200` sin errores, la infraestructura que dimensionaste responde bien. Esto **no** prueba que aguante literalmente el `objetivo_con_margen` que calculaste en 7.2 — esta plataforma no te deja generar esa carga real, la misma limitación de toda la práctica (ver la nota de la intro). Lo que estás confirmando es que el número de workers que calculaste arrancó correctamente y responde; la prueba de que aguanta el pico real es el cálculo de 7.4, no este `curl`.

## 7.7 — Guardá tus tres números

Anotá `T_normal`, `capacidad_por_worker` y `workers_necesarios` (con la cuenta hecha) — te los vamos a pedir en el mini-reporte final de la práctica, junto con lo del Paso 4.

> Con esto cerramos la parte de performance. La misma infraestructura (mismas credenciales, mismos puertos expuestos) que acabás de medir y dimensionar es la que vamos a atacar en la próxima práctica.

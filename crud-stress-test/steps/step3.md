# Paso 3 — Carga sobre un endpoint de escritura

Leer datos (`SELECT`) es barato. Escribir datos (`INSERT`) implica un lock más costoso en la base y, en este caso, un commit por cada petición. Vamos a comprobarlo generando carga sobre `POST /nuevo`, el endpoint que da de alta un alumno.

## 3.1 — Contar los alumnos antes de la prueba

```bash
docker exec $(docker ps -qf "name=mysql") \
  mysql -h 127.0.0.1 -uroot -pmysecretpassword -N -e "SELECT COUNT(*) FROM alumnos.alumnos;"
```

## 3.2 — Generar la carga de escritura

Mismos números que en el Paso 2 (50 peticiones, 5 en simultáneo), para poder comparar directo:

```bash
time ( seq 1 50 | xargs -P 5 -I{} curl -s -o /dev/null -w "%{http_code}\n" \
  -d "nombre=Carga&apellido=DeTest&fecha_nacimiento=2000-01-01" \
  http://127.0.0.1:8888/nuevo | sort | uniq -c )
```

(La respuesta esperada es `302`, no `200` — el endpoint redirige al listado después de guardar, no es una falla.)

## 3.3 — Contar los alumnos después

```bash
docker exec $(docker ps -qf "name=mysql") \
  mysql -h 127.0.0.1 -uroot -pmysecretpassword -N -e "SELECT COUNT(*) FROM alumnos.alumnos;"
```

El número debería haber crecido en 50 (o cerca, si hubo alguna petición fallida).

## 3.4 — Comparar contra el Paso 2

Compará el `real` (tiempo total) de esta corrida contra el de `tiempo-lectura.txt`. Con esta carga tan liviana (50 peticiones, tabla de pocas filas) la diferencia puede ser chica, nula, o incluso ir al revés de lo esperado — a este volumen el ruido de medición pesa tanto como la diferencia real entre un `SELECT` y un `INSERT` con `commit`.

Eso **no es un error tuyo, es la razón por la que existen las herramientas de stress testing reales**: con cientos o miles de peticiones sostenidas, el ruido se promedia y la diferencia entre leer y escribir se vuelve consistente y notoria. Con 50 peticiones sueltas no alcanza para verla con confianza — es la misma razón por la que esta plataforma no te deja generar esa carga real (ver la nota de la intro).

> En el Paso 4 vamos a ver, leyendo el código en vez de forzándolo, por qué esa diferencia se vuelve un problema serio bajo carga real.

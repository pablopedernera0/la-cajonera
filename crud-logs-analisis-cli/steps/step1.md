# Paso 1 — Los logs de la app: encontrando el pico de carga

## 1.1 — Ver el formato del log

```bash
tail -20 /root/crud-python/app.log
```

Cada línea de acceso tiene esta forma:

```
127.0.0.1 - - [04/Aug/2026 13:38:49] "GET / HTTP/1.1" 200 -
```

De izquierda a derecha: IP de origen, timestamp entre corchetes, método y ruta, versión de HTTP, y código de estado.

## 1.2 — Contar pedidos a `/`

```bash
grep -c '"GET / ' /root/crud-python/app.log
```

Un número bastante más alto que "unos pocos usuarios navegando" — pero el conteo total no dice **cuándo** pasó.

## 1.3 — Agrupar por timestamp

```bash
grep '"GET / ' /root/crud-python/app.log | awk -F'[][]' '{print $2}' | sort | uniq -c | sort -rn | head
```

- `awk -F'[][]'` usa `[` y `]` como separadores, así que `$2` es el texto que está entre corchetes: el timestamp
- `sort | uniq -c` cuenta cuántas veces se repite cada timestamp
- `sort -rn` ordena de mayor a menor

## 1.4 — Leer el resultado

Deberías ver algo así:

```
     60 04/Aug/2026 13:39:35
      1 04/Aug/2026 13:38:49
```

**60 peticiones a `/` en el mismo segundo** es imposible de explicar como uso normal — es la firma de un pico de carga generado por una herramienta, no por personas navegando.

> Con el pico de carga identificado, pasá al Paso 2 para buscar algo con una firma distinta: la fuerza bruta contra `/login`.

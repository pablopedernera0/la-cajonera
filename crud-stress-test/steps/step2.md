# Paso 2 — Carga liviana contra un endpoint de lectura

Vamos a arrancar por lo más simple: medir cuánto tarda el endpoint que lista los alumnos (`GET /`), que solo hace una consulta `SELECT` a MySQL.

## 2.1 — Verificar que la app responde

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8888/
```

Debería devolver `200`.

## 2.2 — Primera carga

```bash
time ( seq 1 50 | xargs -P 5 -I{} curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8888/ | sort | uniq -c )
```

Esto manda **50 peticiones** con hasta **5 en simultáneo** (`xargs -P 5`), y agrupa los códigos de respuesta obtenidos.

## 2.3 — Leer el resultado

| Lo que ves | Qué significa |
|---|---|
| `50 200` (una sola línea, todas `200`) | Throughput: sin fallas, la app respondió todo |
| `real` (de `time`) | Tiempo total — dividiendo 50 peticiones por ese tiempo tenés el throughput aproximado |
| Líneas con otro código o menos de 50 en total | Tasa de error: peticiones que fallaron o no llegaron a responder |

## 2.4 — Guardar el resultado para comparar

```bash
{ time ( seq 1 50 | xargs -P 5 -I{} curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8888/ | sort | uniq -c ) ; } 2> tiempo-lectura.txt
cat tiempo-lectura.txt
```

Anotá (o dejá este archivo guardado) el tiempo total — lo vamos a comparar contra los próximos pasos.

> Con 5 en simultáneo, la app debería responder sin problema. Vamos a subir un poco la vara en el próximo paso.

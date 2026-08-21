# Paso 3 — Medir un backend que devuelve JSON

Ahora medimos el otro extremo: un backend que solo contesta datos, sin ninguna página armada alrededor.

## 3.1 — Elegí una URL de esta lista

```bash
obtener-metricas.sh https://fakestoreapi.com/products/1
```

Alternativas:

```bash
obtener-metricas.sh https://dummyjson.com/products/1
obtener-metricas.sh https://jsonplaceholder.typicode.com/posts/1
```

## 3.2 — Repetilo una segunda vez

```bash
obtener-metricas.sh https://fakestoreapi.com/products/1
```

## 3.3 — Anotá los mismos tres datos

De la salida **con gzip**:

- Tamaño descargado (bytes)
- Tiempo primer byte — TTFB (segundos)
- Tiempo total (segundos)

## 3.4 — Mirá si podés, además, el contenido de la respuesta

```bash
curl -s https://fakestoreapi.com/products/1
```

Esto te muestra el JSON real que viajó — comparalo mentalmente contra todo lo que trae una página HTML completa (estructura, estilos, scripts) para la misma cantidad de información útil.

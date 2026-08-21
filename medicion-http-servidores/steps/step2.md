# Paso 2 — Medir una página HTML completa

Vamos a medir un sitio real que arma la página entera en el servidor (HTML + estructura ya lista para pintar en el navegador).

## 2.1 — Elegí una URL de esta lista

```bash
obtener-metricas.sh https://es.wikipedia.org/wiki/Internet
```

Alternativas si preferís probar otra (o si alguna no responde en el momento):

```bash
obtener-metricas.sh https://www.python.org
obtener-metricas.sh https://wordpress.com/log-in
```

## 2.2 — Repetilo una segunda vez

```bash
obtener-metricas.sh https://es.wikipedia.org/wiki/Internet
```

Los tiempos van a variar un poco entre una corrida y otra — es normal, depende de la red y de la carga del servidor en ese momento. Quedate con el tamaño descargado (ese sí es estable) y con un tiempo total representativo.

## 2.3 — Anotá estos tres datos

De la salida **con gzip** (la segunda parte del resultado), anotá:

- Tamaño descargado (bytes)
- Tiempo primer byte — TTFB (segundos)
- Tiempo total (segundos)

Los vas a necesitar en el Paso 4 para armar la comparación final. Podés copiarlos a un archivo de texto propio, a un mail borrador, o simplemente dejar la terminal abierta con el resultado a la vista.

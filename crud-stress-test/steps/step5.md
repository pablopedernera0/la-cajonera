# Paso 5 — Gunicorn: un servidor apto para producción

**Gunicorn** es un servidor WSGI para aplicaciones Python pensado para producción: en vez de un único proceso atendiendo todo, reparte las peticiones entre varios **workers** que corren en paralelo.

## 5.1 — Instalar Gunicorn

```bash
pip3 install gunicorn --break-system-packages --ignore-installed --quiet
```

## 5.2 — Levantar la misma app con Gunicorn

Sin tocar una línea del código, arrancamos la misma app con 4 workers en otro puerto:

```bash
cd /root/crud-python
nohup gunicorn -w 4 -b 0.0.0.0:8889 app:app > /root/crud-python/gunicorn.log 2>&1 &
```

## 5.3 — Verificar que responde

```bash
sleep 2 && curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8889/
```

## 5.4 — Repetir la prueba que rompió la app en el Paso 4

```bash
ab -n 3000 -c 200 -s 5 http://127.0.0.1:8889/
```

## 5.5 — Comparar

| | Flask dev server (8888) | Gunicorn 4 workers (8889) |
|---|---|---|
| Requests per second | (el que anotaste en el Paso 4) | |
| Failed requests | (el que anotaste en el Paso 4) | |

Completá la columna de Gunicorn con el resultado que acabás de obtener. La diferencia no es magia: son 4 procesos atendiendo en paralelo en vez de 1.

## 5.6 — Confirmá los procesos

```bash
ps aux | grep gunicorn | grep -v grep
```

Vas a ver varios procesos `gunicorn` — el master y los 4 workers.

> Con esto cerramos la parte de performance. La misma infraestructura (mismas credenciales, mismos puertos expuestos) que acabás de medir es la que vamos a atacar en la próxima práctica.

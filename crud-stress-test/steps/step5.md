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

## 5.4 — Repetir la carga liviana del Paso 2, ahora contra Gunicorn

```bash
time ( seq 1 50 | xargs -P 5 -I{} curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8889/ | sort | uniq -c )
```

## 5.5 — Confirmá los procesos

```bash
ps aux | grep gunicorn | grep -v grep
```

Vas a ver varios procesos `gunicorn` — el master y los 4 workers — a diferencia del proceso único que viste en el Paso 4.

## 5.6 — Por qué esto resuelve el problema

Con la carga liviana de esta práctica, la diferencia de tiempos entre el Paso 2 (dev server) y este paso puede no notarse mucho — 5 peticiones a la vez no alcanzan a saturar ni siquiera un solo hilo. La diferencia real aparece bajo carga alta: ahí el servidor de desarrollo hace cola con un solo proceso mientras Gunicorn reparte el trabajo entre sus 4 workers en paralelo. Esa comparación con carga real es la que te va a mostrar tu docente.

> Con esto cerramos la parte de performance. La misma infraestructura (mismas credenciales, mismos puertos expuestos) que acabás de medir es la que vamos a atacar en la próxima práctica.

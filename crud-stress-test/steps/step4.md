# Paso 4 — Por qué el servidor de desarrollo no escala

En los pasos anteriores la app respondió sin problema — la carga fue liviana a propósito. Para ver el límite real, con la app rota bajo concurrencia alta, hace falta una prueba de carga de verdad, y **esta plataforma no lo permite**: Killercoda prohíbe explícitamente las herramientas de stress testing, sin importar qué tan fuerte sea la carga que generen. Por eso acá vamos a entender el problema leyendo el código y los procesos, en vez de forzarlo — la demostración con carga real la vas a ver en la computadora de tu docente, corriendo en un entorno aparte.

## 4.1 — Mirá cómo arranca la app Flask

```bash
tail -n 5 /root/crud-python/app.py
```

La última línea es:

```python
app.run(host="0.0.0.0", port=8888, debug=False)
```

`app.run()` sin más parámetros levanta el **servidor de desarrollo** de Flask (Werkzeug), que por defecto es **single-threaded**: atiende una petición a la vez. Mientras una petición espera la respuesta de MySQL, todas las demás quedan haciendo cola.

## 4.2 — Confirmá con los procesos

```bash
ps aux | grep "app.py" | grep -v grep
```

Vas a ver un único proceso Python atendiendo todo el tráfico — no importa cuántas peticiones lleguen a la vez, las procesa de a una.

## 4.3 — Por qué esto importa

Con la concurrencia liviana que probamos (5, 3 peticiones a la vez) ese único hilo alcanza a atender todo sin que se note. Pero apenas la concurrencia real supera lo que un solo hilo puede procesar en serie, el throughput se desploma y empiezan a aparecer fallos y timeouts — eso es exactamente lo que se ve cuando se lleva esta misma app al límite con una herramienta de carga real.

> Este es el motivo por el que ningún framework recomienda `app.run()` en producción. En el Paso 5 vamos a levantar la misma app con un servidor que sí está pensado para esto.

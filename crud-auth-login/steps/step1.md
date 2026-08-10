# Paso 1 — Autenticación, autorización y sesiones

## 1.1 — ¿Por qué una app necesita login?

Cualquier aplicación que maneja datos de otras personas (alumnos, clientes, pacientes) necesita controlar quién puede acceder. Sin login, no hay forma de saber quién hizo qué cambio, ni de limitar el acceso a quien realmente debería tenerlo.

## 1.2 — ¿Qué es una sesión?

HTTP es un protocolo **sin estado**: cada petición es independiente, el servidor no "recuerda" nada entre una y otra por sí solo. Para que un usuario loguee una vez y siga navegando como autenticado, el servidor necesita guardar ese estado en algún lado.

La forma más común es la **sesión**: al loguearse, el servidor guarda un identificador en una cookie del navegador. En cada petición siguiente, el navegador manda esa cookie, y el servidor la usa para saber "este es el mismo usuario que ya inició sesión".

Flask tiene soporte de sesiones incorporado (`flask.session`), que vamos a usar en esta práctica.

## 1.3 — Verificar que la app está corriendo

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8888/login
```

Debería devolver `200`.

## 1.4 — Intentar entrar sin sesión

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8888/
```

Fijate que también devuelve `200` — pero eso es porque `curl` no sigue redirecciones por defecto. Repetí con `-L` y con `-I` para ver qué pasa en realidad:

```bash
curl -sI http://127.0.0.1:8888/
```

Deberías ver un `302 FOUND` con un header `Location: /login`. Sin sesión, la app te redirige al login automáticamente.

> Con la idea de sesión clara, pasá al Paso 2 para leer el código que hace esto posible.

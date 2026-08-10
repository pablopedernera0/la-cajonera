# Paso 2 — Explorando el código del login

## 2.1 — La tabla `usuarios`

```bash
docker exec $(docker ps -qf "name=mysql") \
  mysql -h 127.0.0.1 -uroot -pmysecretpassword -e "SELECT * FROM alumnos.usuarios;"
```

Vas a ver un único usuario sembrado por el `setup.sh`: `admin`.

## 2.2 — La ruta `/login`

```bash
grep -n -A 15 'def login' /root/crud-python/app.py
```

Fijate cómo arma la consulta a la base: toma `usuario` y `password` directamente del formulario y los mete dentro de un string con `f"..."`, para después ejecutarlo con `cur.execute(query)`.

## 2.3 — El "portero" de la app

```bash
grep -n -B 1 -A 4 'def requerir_login' /root/crud-python/app.py
```

Esta función corre **antes de cada petición** (`@app.before_request`). Si la ruta pedida no es `login` ni `static`, y no hay una sesión activa (`session.get("logged_in")`), redirige a `/login`. Así es como quedó protegido todo el CRUD sin tener que tocar sus rutas una por una.

## 2.4 — ¿Cómo se marca la sesión como iniciada?

```bash
grep -n -A 3 'logged_in.*=.*True' /root/crud-python/app.py
```

Cuando la consulta del login devuelve una fila, se guarda `session["logged_in"] = True`. A partir de ahí, el navegador manda la cookie de sesión en cada petición y `requerir_login` la deja pasar.

> Ya viste cómo está armado el login. En el Paso 3 lo vamos a usar de la forma normal, con el usuario sembrado.

# Paso 4 — Cerrando sesión y reflexión final

## 4.1 — Cerrar sesión desde el navegador

En la app, hacé click en **Salir** (arriba a la derecha). Deberías volver a la pantalla de login.

## 4.2 — Cerrar sesión con la cookie de la terminal

```bash
curl -s -b /root/cookies.txt http://127.0.0.1:8888/logout -o /dev/null -w "%{http_code}\n"
```

## 4.3 — Confirmar que la sesión ya no sirve

```bash
curl -s -b /root/cookies.txt -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8888/
```

`/logout` limpia la sesión del lado del servidor (`session.clear()`), así que aunque mandes la misma cookie, ya no te identifica como logueado.

## 4.4 — Un problema que no tiene que ver con el login en sí

Volvé a mirar la tabla `usuarios`:

```bash
docker exec $(docker ps -qf "name=mysql") \
  mysql -h 127.0.0.1 -uroot -pmysecretpassword -e "SELECT * FROM alumnos.usuarios;"
```

La columna `password` se guarda **en texto plano**. El login funciona perfectamente bien desde el punto de vista funcional, pero cualquiera que consiga acceso de lectura a esa tabla (por ejemplo, entrando a PhpMyAdmin con la password de MySQL que vimos hardcodeada en el `app.py`) se lleva la contraseña de `admin` directamente, sin necesidad de romper nada más.

En un sistema real, esa columna debería guardar un **hash** (con `bcrypt` o similar), no la contraseña original.

> Guardá esta observación. En las próximas prácticas vamos a poner a prueba, en serio, qué tan sólida es esta pantalla de login.

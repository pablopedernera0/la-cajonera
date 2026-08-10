# Paso 3 — Iniciando sesión

## 3.1 — Acceder desde el navegador

Hacé click en el ícono **hamburger** (≡) arriba a la derecha, seleccioná **"Traffic / Ports"**, escribí `8888` en **Custom Ports** y hacé click en **Access**.

Deberías caer directo en la pantalla de login (aunque hayas pedido `/`, `requerir_login` te redirigió).

## 3.2 — Iniciar sesión

Ingresá con el usuario sembrado:

- **Usuario:** `admin`
- **Contraseña:** `admin123`

Después de loguearte, deberías ver el listado de alumnos — la misma pantalla de siempre, ahora protegida.

## 3.3 — Repetir el login desde la terminal

Podemos hacer lo mismo con `curl`, guardando la cookie de sesión en un archivo:

```bash
curl -s -c /root/cookies.txt -d "usuario=admin&password=admin123" \
  http://127.0.0.1:8888/login -o /dev/null -w "%{http_code}\n"
```

## 3.4 — Usar la cookie para entrar al CRUD

```bash
curl -s -b /root/cookies.txt -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8888/
```

Esta vez debería devolver `200` directo, sin redirect — la cookie de sesión te identifica como logueado.

## 3.5 — Confirmar sin la cookie

```bash
curl -sI http://127.0.0.1:8888/
```

Sin la cookie (`-b`), volvés a ver el `302` hacia `/login`.

> Con la sesión andando de la forma normal, pasá al Paso 4 para cerrar sesión y hacer la reflexión final.

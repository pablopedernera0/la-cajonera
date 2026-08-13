# ¡Escenario completado!

Le agregaste una pantalla de login a la app CRUD y protegiste todo el sistema detrás de una sesión.

## Lo que hiciste

- **Autenticación vs. autorización** — entendiste la diferencia entre confirmar identidad y decidir permisos
- **Sesiones** — viste cómo Flask usa una cookie para "recordar" que un usuario ya inició sesión
- **Código del login** — leíste la ruta `/login`, la tabla `usuarios` y el `before_request` que protege toda la app
- **Flujo completo** — iniciaste y cerraste sesión tanto desde el navegador como desde la terminal con `curl`
- **Un problema real** — notaste que las contraseñas se guardan en texto plano en la base de datos

## Comandos clave para recordar

| Comando | Para qué sirve |
|---------|----------------|
| `curl -sI <url>` | Ver los headers de la respuesta (útil para ver redirects) |
| `curl -c cookies.txt -d "campo=valor" <url>` | Enviar un POST y guardar las cookies que devuelve el servidor |
| `curl -b cookies.txt <url>` | Reenviar una cookie guardada en una petición posterior |
| `docker exec <container> mysql ...` | Consultar la base de datos directamente desde la terminal |

## Conceptos clave

**Sesión** — mecanismo para que un servidor identifique a un usuario a través de varias peticiones, normalmente vía una cookie.

**`before_request`** — hook de Flask que corre antes de cada petición; acá lo usamos para bloquear el acceso si no hay sesión activa.

**Contraseña en texto plano** — guardar la contraseña tal cual, sin hashear. Si alguien accede a la base de datos, se lleva la contraseña real de cada usuario.

## 📮 Antes de seguir: mini-reporte de la etapa

Mandanos un mensaje corto (mail al docente o la plataforma de la materia) con:

1. La salida de `curl -sI http://127.0.0.1:8888/` sin haber iniciado sesión (el `302` a `/login`).
2. En 2-3 líneas: ¿por qué HTTP necesita un mecanismo de sesión? ¿Qué pasaría si alguien consiguiera copiar tu cookie de sesión?

No suma nota — es un checkpoint para confirmar que la etapa quedó entendida antes de pasar a la siguiente.

## Próximo paso

En las próximas prácticas vamos a atacar esta misma infraestructura: reconocimiento de red, la contraseña de MySQL hardcodeada en el código, fuerza bruta contra el login, y una vulnerabilidad puntual en la forma en que `/login` arma su consulta SQL. Vas a ver que "funciona bien" y "es seguro" no siempre son lo mismo.

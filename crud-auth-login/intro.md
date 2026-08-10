# Login y control de acceso en una app Flask + MySQL

Hasta ahora la app CRUD de alumnos estaba completamente abierta: cualquiera que tuviera la URL podía ver, crear, editar y borrar alumnos. En esta práctica le agregamos una pantalla de login, para que solo usuarios autenticados puedan usarla.

## Autenticación vs. autorización

Son dos conceptos que se confunden seguido:

- **Autenticación**: confirmar que alguien es quien dice ser (usuario + contraseña, por ejemplo).
- **Autorización**: una vez autenticado, decidir qué puede hacer.

Hoy nos enfocamos en la autenticación: agregar un login que confirme la identidad antes de dejar entrar a la app.

## ¿Qué vamos a construir?

Al finalizar esta práctica vas a tener:

- Una tabla `usuarios` en MySQL, con un usuario sembrado
- Una pantalla de **login** (`/login`) en la app Flask
- La app protegida: si no iniciaste sesión, cualquier ruta te redirige al login
- Un botón de **logout** para cerrar sesión

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá este comando para levantar toda la infraestructura:

```bash
bash /root/setup.sh
```

El script levanta Nginx + MySQL + PhpMyAdmin con Docker Compose, crea las tablas `alumnos` y `usuarios` con datos de ejemplo, y clona y arranca la nueva versión de la app Flask (con login) en el puerto 8888.

Cuando termine, vas a ver un resumen con los servicios disponibles. Si todo está bien, continuá con el **Paso 1**.

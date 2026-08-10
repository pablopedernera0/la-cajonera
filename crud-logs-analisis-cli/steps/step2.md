# Paso 2 — Encontrando la fuerza bruta

Un pico de carga es fácil de ver porque son muchas peticiones al mismo endpoint. La fuerza bruta contra `/login` tiene una firma distinta: muchos intentos **fallidos** seguidos de exactamente un **éxito**.

## 2.1 — Aislar los intentos de login

```bash
grep '"POST /login' /root/crud-python/app.log
```

## 2.2 — Contar por código de estado

```bash
grep '"POST /login' /root/crud-python/app.log | awk '{print $9}' | sort | uniq -c
```

`$9` es el noveno campo separado por espacios de la línea — cae justo en el código de estado (contalo en una línea de ejemplo si tenés dudas).

## 2.3 — Leer el resultado

Deberías ver algo así:

```
     10 200
      4 302
```

`200` es la página de login mostrando el error; `302` es un login exitoso (redirect a `/`). Un puñado de `302` está bien — corresponde al login normal del inicio y al que hayas hecho vos mismo. Lo que llama la atención son los **diez `200` seguidos**, todos en el mismo segundo.

## 2.4 — Confirmar que están agrupados en el tiempo

```bash
grep '"POST /login' /root/crud-python/app.log | awk -F'[][]' '{print $2}' | sort | uniq -c
```

Si varios intentos de login caen en el mismo segundo, no fue una persona tipeando — fue un script probando contraseñas de una lista, una atrás de la otra.

## 2.5 — La limitación de este log

Fijate que en ningún momento vimos **qué contraseña** se probó en cada intento. El log de acceso de la app registra método, ruta y resultado — pero no el contenido del formulario. Para eso vamos a necesitar otra fuente, que además nos va a servir para algo más importante: encontrar la inyección SQL.

> En el Paso 3 vamos a leer el log de consultas de MySQL — ahí sí queda registrado el contenido exacto de cada intento.

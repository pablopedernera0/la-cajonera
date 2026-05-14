# Paso 3 — Configurar y arrancar el proyecto

Ya tenemos el bucket creado y las keys en el `.env`. Ahora arrancamos la aplicación CRUD.

## 3.1 — Ir al directorio del proyecto

```bash
cd /root/crud-python
```

## 3.2 — Revisar la estructura del proyecto

```bash
ls -la
```

Vas a ver:

```
app.py          ← aplicación Flask con soporte S3
.env            ← configuración (keys, conexión MySQL y S3)
.env.example    ← ejemplo de referencia
```

## 3.3 — Revisar el .env una vez más

```bash
cat .env
```

Confirmá que:
- `MYSQL_HOST` tiene la IP del contenedor MySQL (no `REEMPLAZAR`)
- `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` tienen las keys del Paso 2
- `S3_ENDPOINT` apunta a `http://localhost:4566`
- `S3_BUCKET` dice `fotos-alumnos`

Si algún valor dice `REEMPLAZAR`, volvé al Paso 2 antes de continuar.

## 3.4 — Arrancar la aplicación

```bash
python3 app.py &
```

Esperamos un momento y verificamos que levantó:

```bash
sleep 2 && curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8888/
```

Si el resultado es `200`, la aplicación está corriendo.

## 3.5 — ¿Qué pasa cuando arranca la app?

Al iniciar, la aplicación ejecuta automáticamente `init_db()`, que agrega la columna `foto_url` a la tabla `alumnos` si no existe. Podés verificarlo:

```bash
docker exec $(docker ps -qf "ancestor=mysql:latest") \
    mysql -uroot -pmysecretpassword alumnos \
    -e "DESCRIBE alumnos;"
```

Deberías ver la columna `foto_url` al final de la tabla.

## 3.6 — Acceder desde el navegador

Para acceder a la aplicación desde el navegador:

1. Hacé click en el ícono **hamburger** (≡) arriba a la derecha
2. Seleccioná **"Traffic / Ports"**
3. En **Custom Ports** escribí `8888` y hacé click en **Access**

Se va a abrir la aplicación CRUD en una nueva pestaña.

> Si ves la lista de alumnos (vacía por ahora), la aplicación está funcionando correctamente. Continuá con el Paso 4.

# Paso 1 — Verificar el entorno

Antes de arrancar, confirmamos que todos los servicios levantaron correctamente.

## 1.1 — Verificar los contenedores Docker

```bash
docker ps
```

Deberías ver dos contenedores corriendo:

| Imagen | Puerto | Descripción |
|--------|--------|-------------|
| `mysql:latest` | interno | Base de datos de la aplicación |
| `hectorvent/floci:latest` | `4566` | Emulador de AWS S3 |

## 1.2 — Verificar que Floci responde

```bash
curl -s http://localhost:4566 | head -c 100
```

Si Floci está listo, vas a recibir una respuesta (puede ser vacía o un mensaje corto — lo importante es que no dé error de conexión).

## 1.3 — Configurar las variables de entorno de AWS CLI

Para usar el AWS CLI apuntando a Floci en lugar de AWS real, necesitamos decirle dónde conectarse y con qué credenciales:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
```

> **¿Por qué `test`?** Floci acepta cualquier credencial — todavía no creamos nuestro usuario IAM real. Lo hacemos en el Paso 2.

## 1.4 — Verificar que el bucket existe

El `setup.sh` ya creó el bucket `fotos-alumnos`. Verificamos:

```bash
aws s3 ls
```

Deberías ver:

```
2024-01-01 00:00:00 fotos-alumnos
```

## 1.5 — Explorar el bucket

```bash
aws s3 ls s3://fotos-alumnos
```

Por ahora está vacío — todavía no subimos ninguna foto. Eso lo hacemos en el Paso 4.

## 1.6 — Ver el archivo .env generado

El `setup.sh` también clonó el proyecto y generó un `.env` con la configuración base:

```bash
cat /root/crud-python/.env
```

Vas a ver que las líneas de `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` dicen `REEMPLAZAR`. Eso es lo que vamos a hacer en el próximo paso.

> Si ves los dos contenedores corriendo y el bucket `fotos-alumnos` en la lista, estás listo para continuar.

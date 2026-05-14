# Paso 5 — Verificar en Floci Panel

**Floci Panel** es una interfaz web que muestra el contenido de los buckets S3 de Floci de forma visual, similar a la consola de AWS. Ya está corriendo desde que ejecutaste el `setup.sh` — no hace falta levantarlo.

## 5.1 — Acceder al panel

1. Hacé click en el ícono **hamburger** (≡) arriba a la derecha
2. Seleccioná **"Traffic / Ports"**
3. En **Custom Ports** escribí `4580` y hacé click en **Access**

Se abre Floci Panel en una nueva pestaña.

## 5.2 — Explorar el bucket

En el panel vas a ver:

- **Sidebar izquierdo** — S3 e IAM
- **Lista de buckets** — aparece `fotos-alumnos`
- Al hacer click en el bucket — los objetos subidos con nombre (key), tamaño y fecha
- Al hacer click en un objeto — preview con los metadatos del archivo

## 5.3 — Verificar los objetos subidos

Cada foto que subiste en el Paso 4 aparece como un objeto con la key `alumnos/<id>.png` o `alumnos/<id>.jpg`. El panel muestra:

| Campo | Descripción |
|-------|-------------|
| Nombre (key) | Ruta del objeto dentro del bucket |
| Tamaño | Peso del archivo en KB o MB |
| Última modificación | Fecha y hora de la subida |
| Tipo | Extensión del archivo (png, jpg) |

## 5.4 — Verificar usuarios IAM

Hacé click en **IAM** en el sidebar. Vas a ver el usuario `alumno` que creaste en el Paso 2 con su ARN y fecha de creación.

## 5.5 — Verificación alternativa por CLI

Si preferís confirmar desde la terminal:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
```

```bash
# Listar objetos en el bucket
aws s3 ls s3://fotos-alumnos/ --recursive
```

```bash
# Ver metadatos de un objeto específico
aws s3api head-object \
  --bucket fotos-alumnos \
  --key alumnos/1.jpg
```

## 5.6 — Reflexión

Lo que construiste en esta práctica es exactamente el flujo que se usa en producción:

- Una aplicación que delega el almacenamiento de archivos a S3
- Credenciales IAM propias, separadas de las credenciales root
- Objetos organizados por key dentro de un bucket
- Verificación visual y por CLI del estado del almacenamiento

La única diferencia con AWS real es el endpoint — en producción sería `https://s3.amazonaws.com` en lugar de `http://localhost:4566`. El código es idéntico.

> Si ves los objetos en el panel y los usuarios IAM en la sección IAM, completaste la práctica correctamente.
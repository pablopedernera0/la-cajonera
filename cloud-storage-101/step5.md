# Paso 5 — Verificar en Floci Panel

**Floci Panel** es una interfaz web que muestra el contenido de los buckets S3 de Floci de forma visual, similar a la consola de AWS. En este paso la levantamos y verificamos que los archivos subidos en el Paso 4 están realmente almacenados.

## 5.1 — Levantar Floci Panel

```bash
docker run -d \
  --name floci-panel \
  --network cloud-storage-101_redpractica \
  -p 4580:80 \
  -e FLOCI_ENDPOINT=http://floci:4566 \
  -e FLOCI_REGION=us-east-1 \
  -e FLOCI_ACCESS_KEY=test \
  -e FLOCI_SECRET_KEY=test \
  ghcr.io/pablopedernera0/floci-panel:latest
```

> **Nota:** Floci Panel todavía está en desarrollo como parte de este proyecto educativo. Si la imagen no está disponible aún, usá la verificación por CLI del punto 5.4.

## 5.2 — Acceder al panel

1. Hacé click en el ícono **hamburger** (≡) arriba a la derecha
2. Seleccioná **"Traffic / Ports"**
3. En **Custom Ports** escribí `4580` y hacé click en **Access**

## 5.3 — Explorar el panel

En el panel vas a ver:

- **Lista de buckets** — debería aparecer `fotos-alumnos`
- Al hacer click en el bucket, los **objetos almacenados** con nombre, tamaño y fecha
- Al hacer click en un objeto, una **preview** de la imagen

Esto es exactamente lo que muestra la consola de AWS S3, pero con tu Floci local.

## 5.4 — Verificación alternativa por CLI

Si el panel no está disponible, podés verificar todo desde la terminal:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
```

**Listar todos los buckets:**
```bash
aws s3 ls
```

**Listar el contenido del bucket:**
```bash
aws s3 ls s3://fotos-alumnos/ --recursive
```

**Ver los metadatos de un objeto:**
```bash
aws s3api head-object \
  --bucket fotos-alumnos \
  --key alumnos/1.jpg
```

La respuesta incluye el `ContentType`, tamaño y fecha de la última modificación.

## 5.5 — Reflexión

Pensá en lo que construiste en esta práctica:

- Una aplicación real que usa S3 como almacenamiento de archivos
- Credenciales IAM generadas correctamente, separadas de las credenciales root
- Un bucket con objetos organizados por clave (`alumnos/<id>.jpg`)
- Verificación visual y por CLI del estado del almacenamiento

Este es exactamente el flujo que se usa en producción con AWS real. La única diferencia es el endpoint — en vez de `http://localhost:4566` sería `https://s3.amazonaws.com`.

> Si ves los archivos en el panel o en la salida de `aws s3 ls`, completaste la práctica correctamente.

# ¡Escenario completado!

Trabajaste con almacenamiento en la nube estilo AWS S3 usando un emulador real y una aplicación funcional.

## Lo que hiciste

- **Floci** — levantaste un emulador de AWS S3 con Docker y verificaste que respondía en el puerto 4566
- **S3** — exploraste el concepto de bucket y objetos, y usaste el AWS CLI para interactuar con el servicio
- **IAM** — creaste un usuario con `aws iam create-user`, generaste sus API Keys y entendiste por qué no se usan las credenciales root en aplicaciones
- **Variables de entorno** — configuraste un `.env` con las credenciales y parámetros de conexión, separando la configuración del código
- **Integración S3 en Python** — usaste `boto3` para subir archivos a S3 desde una aplicación Flask real
- **Verificación** — confirmaste que los archivos están en el bucket tanto por CLI como visualmente

## Comandos clave para recordar

| Comando | Para qué sirve |
|---------|----------------|
| `aws s3 ls` | Listar buckets |
| `aws s3 ls s3://<bucket>/` | Listar objetos en un bucket |
| `aws s3 mb s3://<bucket>` | Crear un bucket |
| `aws s3 cp <archivo> s3://<bucket>/` | Subir un archivo |
| `aws s3 presign s3://<bucket>/<key>` | Generar URL temporal de acceso |
| `aws iam create-user --user-name <nombre>` | Crear usuario IAM |
| `aws iam create-access-key --user-name <nombre>` | Generar API Keys |
| `aws iam list-users` | Listar usuarios IAM |

## Conceptos clave

**Bucket** — contenedor de objetos en S3. Nombre único global en AWS real.

**Objeto** — cualquier archivo almacenado en S3, identificado por su key (ruta).

**Key** — nombre del objeto dentro del bucket. Puede tener barras (`/`) que simulan carpetas, pero no son carpetas reales.

**IAM** — sistema de gestión de identidades. Siempre usar usuarios con permisos específicos, nunca credenciales root en aplicaciones.

**Endpoint** — dirección del servicio. En Floci es `http://localhost:4566`. En AWS real es `https://s3.amazonaws.com`. El código es idéntico.

## Próximo paso

En el siguiente escenario vas a trabajar con **colas de mensajes (SQS)** — otro servicio fundamental de AWS que permite comunicar servicios entre sí de forma desacoplada.

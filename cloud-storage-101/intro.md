# Cloud Storage 101 — S3 con Floci

En esta práctica vas a trabajar con **almacenamiento en la nube estilo AWS S3**, usando un emulador local llamado **Floci** que simula los servicios de AWS sin necesidad de una cuenta real ni tarjeta de crédito.

## ¿Qué es S3?

**Amazon S3 (Simple Storage Service)** es el servicio de almacenamiento de objetos más usado en la industria. Se utiliza para guardar archivos de todo tipo: imágenes, documentos, backups, videos, logs, y más.

A diferencia de un sistema de archivos tradicional, S3 organiza los archivos en **buckets** (contenedores) y cada archivo se identifica por una **clave** (key). No hay carpetas reales — todo es un objeto con una ruta.

## ¿Qué es Floci?

**Floci** es un emulador de AWS de código abierto y gratuito. Corre en Docker y simula los servicios de AWS usando exactamente la misma API — los comandos y el código que uses acá funcionan igual en AWS real.

Esto significa que lo que aprendés hoy lo podés aplicar directamente en producción.

## ¿Qué es IAM?

**IAM (Identity and Access Management)** es el sistema de gestión de identidades de AWS. Permite crear usuarios, roles y políticas que controlan quién puede hacer qué sobre qué recursos.

En esta práctica vas a crear un usuario IAM y generar sus **API Keys** — las credenciales que una aplicación usa para autenticarse contra AWS (o Floci).

## ¿Qué vamos a construir?

Al finalizar esta práctica vas a tener:

- **Floci** corriendo en Docker, emulando AWS S3
- Un **bucket S3** llamado `fotos-alumnos`
- Un **usuario IAM** con sus propias API Keys
- Una **aplicación web CRUD** conectada a S3, que permite subir fotos de alumnos
- Un **panel web** donde podés ver los archivos almacenados en el bucket

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá este comando para preparar el entorno:

```bash
bash /root/setup.sh
```

El script va a instalar las dependencias, levantar los servicios y dejarte todo listo para trabajar. Puede tardar un par de minutos.

Cuando termine, vas a ver un resumen con los servicios disponibles. Si todo está bien, continuá con el **Paso 1**.

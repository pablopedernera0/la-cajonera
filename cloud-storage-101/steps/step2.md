# Paso 2 — Crear usuario IAM y API Keys

En AWS, las aplicaciones no se conectan con usuario y contraseña — usan **API Keys**: un par de credenciales (Access Key ID + Secret Access Key) asociadas a un usuario IAM.

En este paso vas a crear tu propio usuario IAM dentro de Floci y generar sus keys.

## 2.1 — Confirmar las variables de entorno

Si abriste una terminal nueva, volvé a exportar las variables:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
```

## 2.2 — Crear el usuario IAM

```bash
aws iam create-user --user-name alumno
```

Vas a ver una respuesta JSON con los datos del usuario creado:

```json
{
    "User": {
        "UserId": "...",
        "UserName": "alumno",
        "Arn": "arn:aws:iam::000000000000:user/alumno",
        ...
    }
}
```

El campo `Arn` es el identificador único del usuario dentro del sistema IAM.

## 2.3 — Generar las API Keys

```bash
aws iam create-access-key --user-name alumno
```

La respuesta va a tener este formato:

```json
{
    "AccessKey": {
        "UserName": "alumno",
        "AccessKeyId": "AKIA...",
        "SecretAccessKey": "abc123...",
        "Status": "Active"
    }
}
```

> **⚠️ Importante:** copiá los valores de `AccessKeyId` y `SecretAccessKey` ahora. El `SecretAccessKey` no se puede volver a ver después — si lo perdés, hay que generar uno nuevo.

## 2.4 — Guardar las keys en el .env

Abrí el archivo `.env` del proyecto:

```bash
nano /root/crud-python/.env
```

Reemplazá las líneas:

```
AWS_ACCESS_KEY_ID=REEMPLAZAR
AWS_SECRET_ACCESS_KEY=REEMPLAZAR
```

Con los valores que obtuviste en el paso anterior. Guardá con `Ctrl+O`, `Enter`, y salí con `Ctrl+X`.

## 2.5 — Verificar el archivo

```bash
cat /root/crud-python/.env
```

Confirmá que las dos keys están completas y no dicen `REEMPLAZAR`.

## 2.6 — Listar los usuarios IAM

```bash
aws iam list-users
```

Deberías ver el usuario `alumno` en la lista.

## 2.7 — ¿Por qué esto es importante?

En AWS real, cada aplicación tiene su propio usuario IAM con permisos específicos. Esto permite:

- **Auditoría:** saber qué aplicación hizo qué
- **Principio de mínimo privilegio:** cada usuario solo puede hacer lo que necesita
- **Rotación de credenciales:** si una key se filtra, se desactiva sin afectar al resto

En producción nunca se usan las credenciales del usuario root (equivalente al `test` que usamos al principio).

> Si el `.env` tiene las dos keys completas, estás listo para el Paso 3.

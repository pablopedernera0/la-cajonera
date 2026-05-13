# Paso 4 — Usar el CRUD y subir fotos

La aplicación está corriendo y conectada tanto a MySQL como a Floci. Ahora cargamos algunos alumnos con sus fotos y verificamos que todo funcione.

## 4.1 — Crear un alumno con foto

En la aplicación abierta en el navegador:

1. Hacé click en **+ Nuevo alumno**
2. Completá nombre, apellido y fecha de nacimiento
3. En el campo **Foto del alumno**, seleccioná una imagen desde tu computadora (JPG o PNG)
4. Hacé click en **Guardar**

El alumno debería aparecer en el listado con su foto como thumbnail circular.

## 4.2 — ¿Qué pasó por detrás?

Cuando guardaste el formulario, la aplicación hizo tres cosas:

1. **Insertó el registro** en MySQL con nombre, apellido y fecha
2. **Subió la foto** a Floci usando la API de S3, guardándola como `alumnos/<id>.jpg` dentro del bucket `fotos-alumnos`
3. **Guardó la URL** de la foto en la columna `foto_url` de MySQL

Esa URL apunta directamente a Floci — la misma forma en que en producción apuntaría a AWS S3.

## 4.3 — Verificar desde la terminal

Podemos confirmar que la foto llegó a S3 desde la terminal:

```bash
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566

aws s3 ls s3://fotos-alumnos/alumnos/
```

Deberías ver el archivo de la foto que subiste, con su tamaño y fecha.

## 4.4 — Crear más alumnos

Cargá al menos **dos o tres alumnos más**, con y sin foto, para tener datos variados para verificar en el Paso 5.

- Un alumno con foto
- Un alumno sin foto (el campo foto es opcional)

## 4.5 — Editar un alumno y cambiar la foto

1. Hacé click en **Editar** sobre un alumno existente
2. La foto actual aparece como preview
3. Seleccioná una foto nueva y guardá
4. Verificá que el listado muestra la foto actualizada

Desde la terminal:

```bash
aws s3 ls s3://fotos-alumnos/alumnos/
```

El archivo se reemplaza en S3 — misma key, nuevo contenido.

## 4.6 — Ver la URL de una foto directamente

```bash
aws s3 presign s3://fotos-alumnos/alumnos/1.jpg --expires-in 300
```

Este comando genera una URL temporal (válida 5 minutos) para acceder al objeto. En AWS real esto se usa para compartir archivos privados sin hacerlos públicos permanentemente.

> Si ves los archivos listados en `aws s3 ls s3://fotos-alumnos/alumnos/`, el flujo completo está funcionando. Continuá con el Paso 5 para verificarlo visualmente en el panel web.

# Trabajo práctico — Cloud Storage 101 (S3 con Floci)

_Respondé estas 5 preguntas en base a lo que hiciste en la práctica. No hace falta que sea
extenso — priorizá explicarlo con tus propias palabras y, donde se pida, con ejemplos
concretos de tu propia corrida (buckets, keys, usuarios que creaste, etc.)._

---

## 1 — Buckets y keys

_En S3 no existen carpetas reales, aunque las keys tengan `/` (como `alumnos/1.jpg`)._

Explicá qué es un bucket, qué es una key, y por qué decimos que S3 es "almacenamiento de
objetos" y no un sistema de archivos tradicional. Dá un ejemplo con una key que hayas visto
en tu práctica.

**Tu respuesta:**



---

## 2 — IAM y el problema de las credenciales root

_Al principio de la práctica usaste las credenciales `test`/`test` (equivalentes a root)
para poder crear el usuario `alumno`._

Una vez que generaste las API Keys de `alumno`, ¿por qué en una aplicación real nunca se
usan las credenciales root? Mencioná al menos dos ventajas concretas de tener un usuario
IAM propio por aplicación.

**Tu respuesta:**



---

## 3 — El ciclo de vida de una API Key

_Cuando ejecutaste `aws iam create-access-key`, el `SecretAccessKey` se mostró una única vez._

¿Qué implica esto en términos de seguridad? ¿Qué tendrías que hacer si un
`SecretAccessKey` se filtra (por ejemplo, quedó subido por error a un repositorio público
de GitHub)?

**Tu respuesta:**



---

## 4 — Portabilidad: de Floci a AWS real

_Todo el código de la aplicación (`boto3`, el CRUD en Flask) funciona igual contra Floci
que contra AWS real — lo único que cambia es el endpoint._

Explicá qué es el endpoint en este contexto y por qué esta característica (mismo código,
distinto endpoint) es valiosa para una empresa que recién empieza a migrar a la nube.

**Tu respuesta:**



---

## 5 — URLs presignadas

_Generaste una URL con `aws s3 presign` válida por 5 minutos, sobre un bucket que no es
público._

¿Para qué sirve una URL presignada y en qué caso de uso real la usarías? Comparalo con la
alternativa de hacer el bucket público — ¿qué riesgo evita el presign?

**Tu respuesta:**


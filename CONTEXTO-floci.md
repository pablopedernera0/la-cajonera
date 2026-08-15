# Contexto del proyecto — Prácticas Cloud con Floci

## Quién
Pablo Pedernera — profesor de Infraestructura de Redes en un instituto Terciario.
Usa KillerCoda para montar prácticas. Ya tiene experiencia con Docker, Flask, MySQL.

---

## El ecosistema construido

### Repositorios

| Repo | Descripción |
|------|-------------|
| `github.com/pablopedernera0/floci-edu` | Fork de Floci (control de versión propio) + floci-panel adentro |
| `github.com/pablopedernera0/crud-python` branch `aws-s3-floci` | CRUD Python/Flask modificado con soporte S3 |
| `github.com/pablopedernera0/la-cajonera/cloud-storage-101` | Escenario KillerCoda completo |

### Imagen Docker publicada
```
ghcr.io/pablopedernera0/floci-panel:latest
```
Se rebuilde automáticamente con GitHub Actions cada push a `main` con cambios en `floci-panel/`.

---

## Arquitectura del escenario

```
KillerCoda (Ubuntu)
├── docker-compose.yml  (en /root/cloud-storage-101/)
│   ├── mysql:latest            → red interna
│   ├── hectorvent/floci:latest → puerto 4566
│   └── floci-panel:latest      → puerto 4580
└── Flask app (crud-python)     → puerto 8888
```

---

## Archivos clave

### `floci-edu/floci-panel/`
```
app.py              ← Flask proxy hacia Floci (API S3 e IAM)
templates/index.html ← UI completa: buckets, objetos, preview, IAM
Dockerfile
requirements.txt    ← flask, boto3, botocore
```

### `crud-python/` (branch aws-s3-floci)
```
app.py              ← CRUD Flask + upload S3 via boto3
.env.example        ← template de variables de entorno
```

Variables de entorno del `.env`:
```
MYSQL_HOST, MYSQL_PORT, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE
S3_ENDPOINT=http://localhost:4566
S3_PUBLIC_URL=https://<token>-4566.saci.r.killercoda.com  ← generado por setup.sh
S3_REGION=us-east-1
S3_BUCKET=fotos-alumnos
AWS_ACCESS_KEY_ID   ← el alumno la genera en el Paso 2
AWS_SECRET_ACCESS_KEY
```

### `la-cajonera/cloud-storage-101/`
```
index.json
intro.md
finish.md
assets/
    setup.sh            ← instala deps, levanta docker-compose, crea bucket, clona CRUD
    table_alumnos.sql   ← CREATE TABLE alumnos (el alumno lo ejecuta en el Paso 1)
step1/step1.md      ← verificar entorno, crear tabla, configurar AWS CLI
step2/step2.md      ← crear usuario IAM y API Keys
step3/step3.md      ← configurar .env y arrancar Flask
step4/step4.md      ← usar el CRUD, subir fotos
step5/step5.md      ← verificar en floci-panel (puerto 4580)
```

---

## Decisiones técnicas importantes

**¿Por qué floci-panel es un servicio separado y no parte de floci-edu?**
Más simple de mantener. El panel es un Flask que actúa como proxy — el browser no habla directo con Floci (evita CORS). El browser habla con el panel en el puerto 4580, y el panel habla con Floci en la red Docker interna.

**¿Por qué S3_PUBLIC_URL?**
Las URLs de S3 que genera Floci apuntan a `localhost:4566`. Dentro de KillerCoda el browser está en la máquina del alumno, no en el servidor — no puede acceder a `localhost`. KillerCoda expone los puertos con URLs públicas del tipo `https://<token>-PORT.saci.r.killercoda.com`. El archivo `/etc/killercoda/host` tiene esa URL con `PORT` como placeholder. El `setup.sh` lo lee y reemplaza `PORT` por `4566`.

**¿Por qué table_alumnos.sql como asset?**
El `setup.sh` intentaba crear la tabla via `docker exec`, pero MySQL no estaba listo a tiempo y fallaba. Se separó la creación de la tabla al Paso 1 del escenario — tiene más sentido pedagógico y es más confiable.

**awscli se instala via pip, no apt**
En KillerCoda el paquete `awscli` no está disponible en los repos de Ubuntu. Se instala con:
```bash
pip3 install awscli --break-system-packages --ignore-installed
```

---

## Problemas resueltos y sus soluciones

| Problema | Solución |
|----------|----------|
| `awscli` no disponible en apt de KillerCoda | Instalar via pip3 |
| `blinker` conflict al instalar con pip | Agregar `--ignore-installed` |
| Tabla `alumnos` no existe al arrancar Flask | Crear via `table_alumnos.sql` en el Paso 1 |
| `docker ps -qf "ancestor=mysql"` devuelve vacío | Usar `name=mysql` en el filtro |
| MySQL rechaza conexión con `docker exec` | Agregar `-h 127.0.0.1` al comando mysql |
| Fotos no se ven en el browser (URL localhost) | `S3_PUBLIC_URL` con URL pública de KillerCoda |
| Firma de URL presignada inválida al cambiar host | Usar URL directa sin firma en lugar de presign |

---

## Próximos pasos planificados

### `cloud-compute-102` — EC2 con Floci
Floci soporta EC2. El siguiente escenario podría cubrir:
- Lanzar instancias EC2
- Configurar security groups
- Asignar IPs
- Todo el flujo real de infraestructura cloud

### Serie completa pensada
```
cloud-storage-101   ✅  S3 + IAM
cloud-compute-102   🔜  EC2
cloud-network-103   💡  VPC, subnets, security groups
```

---

## Comandos útiles para retomar

```bash
# Ver la imagen publicada
docker pull ghcr.io/pablopedernera0/floci-panel:latest

# Probar el escenario localmente
mkdir ~/prueba && cd ~/prueba
# (copiar docker-compose.yml del repo)
docker compose up -d
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://localhost:4566
aws s3 mb s3://fotos-alumnos

# Forzar rebuild del floci-panel
# → ir a github.com/pablopedernera0/floci-edu → Actions → "Publicar floci-panel en GHCR" → Run workflow
```

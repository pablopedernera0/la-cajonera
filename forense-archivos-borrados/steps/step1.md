# Paso 1 — Las imágenes y su hash

Una **imagen forense** es una copia exacta, bit a bit, de un disco: incluye los archivos, pero también el espacio libre, lo borrado y las estructuras del sistema de archivos. En un caso real se obtiene con un bloqueador de escritura, para que conectar el disco no lo modifique, y se analiza siempre la copia, nunca el original.

## 1.1 — Las imágenes

```bash
ls -l /root/imagenes/
```

Cada imagen mide **1 073 742 336 bytes** (1 GB): es un disco completo. Fijate también en los permisos `-r--r--r--`: el setup las dejó en **solo lectura**, así nadie las modifica por error.

## 1.2 — El hash: la huella de la evidencia

Un **hash** SHA-256 es un número de 64 caracteres hexadecimales calculado a partir de todo el contenido de un archivo. Tiene dos propiedades clave:

- Los mismos datos dan **siempre** el mismo hash.
- Si cambia **un solo bit**, el hash cambia por completo.

Mirá el registro que guardó el setup al descargar las imágenes:

```bash
cat /root/imagenes/hashes.sha256
```

Deberías ver exactamente estos valores:

```
5d5bf8fb15a1df463fb0b9c0a958c05ece30941af40545f895131ff0daf32fab  dfr-01-fat.dd
29a95ed06e5114106a6e3336fdf25361799157d8613cdac3b318bff2ac89b9fb  dfr-07-fat.dd
```

Esos hashes se calcularon en otra máquina, al preparar esta guía, sobre las mismas imágenes de NIST. Si coinciden con los tuyos, tenés la garantía de estar analizando **exactamente** la misma evidencia, byte por byte.

## 1.3 — Verificar antes de empezar

`sha256sum -c` recalcula el hash de cada archivo y lo compara con el registro:

```bash
cd /root/imagenes
sha256sum -c hashes.sha256
```

```
dfr-01-fat.dd: OK
dfr-07-fat.dd: OK
```

> **Por qué importa:** en un peritaje, este registro va en el **acta** junto con la fecha, el lugar y quiénes estuvieron presentes. Al final del análisis se vuelve a verificar: si el hash cambió, la evidencia fue modificada y hay que explicar por qué. Eso es la base de la **cadena de custodia**.

> Si viste `OK` en las dos imágenes, estás listo para continuar.

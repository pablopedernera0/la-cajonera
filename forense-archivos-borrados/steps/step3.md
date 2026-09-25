# Paso 3 — Listar el sistema de archivos

Dentro de cada partición hay un **sistema de archivos** (acá, FAT): la estructura que organiza los archivos, sus nombres, sus fechas y en qué parte del disco está cada uno.

## 3.1 — ¿Qué sistema de archivos hay de verdad?

`fsstat` lee la estructura del sistema de archivos que empieza en el offset indicado:

```bash
cd /root/imagenes
fsstat -o 128 dfr-01-fat.dd | head -12
```

Mirá la línea `File System Type`. La tabla de particiones del Paso 2 decía **FAT12**, pero `fsstat` dice **FAT16**.

La tabla de particiones solo tiene una **etiqueta** que dice qué se *supone* que hay adentro; `fsstat` lee el sistema de archivos real. Cuando no coinciden, lo que vale es lo que hay en el disco, no la etiqueta. Por eso en forense se verifica, no se asume.

## 3.2 — Listar los archivos, incluidos los borrados

`fls` lista las entradas del sistema de archivos. Con `-r` recorre también las subcarpetas:

```bash
fls -r -o 128 dfr-01-fat.dd
```

```
r/r 3:	FAT12       (Volume Label Entry)
r/r 4:	XALTIR.TXT
r/r * 5:	_BEID.TXT
r/r 6:	XCAPH.TXT
v/v 259971:	$MBR
...
```

| Qué ves | Significado |
|---|---|
| `r/r` | Es un archivo común (*regular file*) |
| El número (`4`, `5`, `6`) | La **dirección** de la entrada: con ese número se pide información o contenido del archivo |
| `*` | La entrada está **borrada** |
| `v/v ... $MBR`, `$FAT1` | Entradas virtuales que agrega The Sleuth Kit para mostrar estructuras internas; no son archivos del usuario |

## 3.3 — ¿Por qué `_BEID.TXT`?

NIST documenta que el archivo borrado se llamaba **`XBEID.TXT`**. En FAT, borrar un archivo reemplaza el **primer carácter** del nombre por un byte especial (`0xE5`) que significa "entrada libre". El resto del nombre, el tamaño, las fechas y dónde empezaba el archivo **siguen ahí**. The Sleuth Kit muestra ese primer carácter perdido como `_`.

## 3.4 — Las otras dos particiones

Repetí el listado con los otros dos offsets:

```bash
fls -r -o 16512 dfr-01-fat.dd
fls -r -o 82048 dfr-01-fat.dd
```

En cada una hay exactamente un archivo con `*`: `Betelgeuse.txt` y `Bellatrix.txt`. Estos conservan el nombre completo, porque además del nombre corto al estilo DOS, FAT guarda un **nombre largo** en entradas aparte, y The Sleuth Kit lo reconstruye desde ahí.

Para listar **solo** lo borrado, se agrega `-d`:

```bash
fls -r -d -o 82048 dfr-01-fat.dd
```

> **Comparalo con NIST:** el documento dice `3 files deleted` y los nombra: `XBEID.TXT`, `Betelgeuse.txt` y `Bellatrix.txt`, uno por partición. ¿Encontraste los tres?

> Si encontraste un archivo borrado en cada partición, estás listo para continuar.

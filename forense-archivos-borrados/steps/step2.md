# Paso 2 — Las particiones

Un disco se divide en **particiones**, y la **tabla de particiones** (al principio del disco) dice dónde empieza y dónde termina cada una. Vamos a leerla sin montar nada: las herramientas de The Sleuth Kit leen la imagen directamente, en modo solo lectura.

## 2.1 — Leer la tabla con `mmls`

```bash
cd /root/imagenes
mmls dfr-01-fat.dd
```

```
DOS Partition Table
Offset Sector: 0
Units are in 512-byte sectors

      Slot      Start        End          Length       Description
000:  Meta      0000000000   0000000000   0000000001   Primary Table (#0)
001:  -------   0000000000   0000000127   0000000128   Unallocated
002:  000:000   0000000128   0000016511   0000016384   DOS FAT12 (0x01)
003:  000:001   0000016512   0000082047   0000065536   DOS FAT16 (0x06)
004:  000:002   0000082048   0000213119   0000131072   Win95 FAT32 (0x0b)
005:  -------   0000213120   0002097152   0001884033   Unallocated
```

| Columna | Significado |
|---|---|
| `Start` / `End` | Primer y último **sector** de cada zona. Un sector mide 512 bytes |
| `Length` | Cuántos sectores ocupa |
| `Description` | El tipo de partición que dice la tabla |
| `Unallocated` | Zonas del disco que no pertenecen a ninguna partición |

## 2.2 — Del sector al tamaño

La tabla habla en sectores. Para pasarlo a bytes, se multiplica por 512:

```bash
echo "Partición 1: $((16384 * 512 / 1024 / 1024)) MB"
echo "Partición 2: $((65536 * 512 / 1024 / 1024)) MB"
echo "Partición 3: $((131072 * 512 / 1024 / 1024)) MB"
```

Son 8, 32 y 64 MB. El resto del disco de 1 GB está sin usar.

## 2.3 — El número que vas a usar en todo el resto: el *offset*

Para analizar el sistema de archivos de una partición, las herramientas necesitan saber **en qué sector empieza**. Ese número se pasa con la opción `-o` (*offset*):

| Partición | Offset (`-o`) |
|---|---|
| 1 | `128` |
| 2 | `16512` |
| 3 | `82048` |

Anotalos: los vas a usar en todos los pasos que siguen.

> **Comparalo con NIST:** en el documento de NIST, buscá la sección `DFR-01. Recover one non-fragmented file.` que tiene particiones FAT. La tabla de particiones que muestra (`/dev/sdd1 128 16511 ... FAT12`, etc.) coincide con la tuya sector por sector.

> Si tenés anotados los tres offsets, estás listo para continuar.

# Paso 4 — Recuperar un archivo borrado

## 4.1 — Lo que el sistema de archivos todavía sabe

`istat` muestra todo lo que el sistema de archivos guarda sobre una entrada. Pedí la del archivo borrado de la partición 1 (entrada `5`):

```bash
cd /root/imagenes
istat -o 128 dfr-01-fat.dd 5
```

```
Directory Entry: 5
Not Allocated
File Attributes: File, Archive
Size: 712
Name: _BEID.TXT

Directory Entry Times:
Written:	2000-02-29 14:11:00 (UTC)
Accessed:	1999-01-02 00:00:00 (UTC)
Created:	2011-12-25 14:02:23 (UTC)

Sectors:
170 171
```

| Campo | Significado |
|---|---|
| `Not Allocated` | La entrada está marcada como libre: el archivo fue borrado |
| `Size` | El tamaño que tenía el archivo: 712 bytes |
| `Written` / `Accessed` / `Created` | Las fechas de última modificación, último acceso y creación |
| `Sectors` | Los sectores de la partición donde estaban sus datos |

El archivo está borrado, pero el sistema de archivos todavía recuerda su tamaño, sus fechas y **dónde estaban sus datos**.

## 4.2 — Recuperar el contenido

`icat` lee esos sectores y devuelve el contenido. Guardalo en la carpeta de trabajo, nunca junto a la evidencia:

```bash
icat -o 128 dfr-01-fat.dd 5 > /root/recuperados/XBEID.TXT
wc -c /root/recuperados/XBEID.TXT
head -c 200 /root/recuperados/XBEID.TXT
```

Son **712 bytes**, igual que el tamaño que documenta NIST, y el contenido empieza con `File XBEID.TXT path root`. NIST escribe el nombre de cada archivo dentro de su contenido justamente para que, al recuperarlo, se pueda comprobar que es el correcto.

## 4.3 — Las otras dos particiones

```bash
icat -o 16512 dfr-01-fat.dd 8 > /root/recuperados/Betelgeuse.txt
icat -o 82048 dfr-01-fat.dd 7 > /root/recuperados/Bellatrix.txt
wc -c /root/recuperados/*
```

Los tres dan **712 bytes**, igual que lo que documenta NIST. Como después de borrarlos no se escribió nada nuevo (`No overwrites`, dice el documento), los datos estaban intactos.

> **Ojo con el número de entrada:** cada partición tiene su propia numeración. La entrada `5` es el archivo borrado en la partición 1, pero en la partición 2 es `Alcor.TXT`, un archivo que **no** fue borrado. Si le pedís a `icat` la entrada equivocada, te devuelve otro archivo sin ningún aviso. Por eso siempre conviene confirmar con `istat` y mirar el contenido antes de dar algo por recuperado.

## 4.4 — Un archivo, dos sectores

Mirá qué sectores tenía `Betelgeuse.txt`:

```bash
istat -o 16512 dfr-01-fat.dd 8 | grep -A1 Sectors
```

Son **dos**: `546` y `547`. Un sector mide 512 bytes, así que un archivo de 712 bytes necesita dos. Miralos por separado con `blkcat`, que muestra el contenido de un sector:

```bash
blkcat -o 16512 dfr-01-fat.dd 546 | head -c 60; echo
blkcat -o 16512 dfr-01-fat.dd 547 | head -c 60; echo
```

El primero empieza con `File Betelgeuse.txt` y el segundo con `Tail Betelgeuse.txt`: NIST marcó el comienzo y el final de cada archivo para que se pueda comprobar que se recuperó entero. `icat` no hace magia: lee esos sectores en orden y los junta.

> **Para qué existen estas imágenes:** NIST las creó para **probar herramientas forenses**, sabiendo de antemano la respuesta correcta. Acabás de hacer lo mismo en chiquito: comparaste lo que devolvió la herramienta con lo que se sabía que había.

> **Sobre las fechas:** si comparás con NIST, las horas no coinciden exactamente (hay una hora de diferencia). FAT guarda la fecha y la hora **sin zona horaria**, así que interpretarlas bien requiere saber cómo estaba configurado el equipo que escribió el disco. Por eso, en un informe, las fechas de un sistema FAT se presentan aclarando esa incertidumbre.

> Si recuperaste los tres archivos completos, 712 bytes cada uno, estás listo para continuar.

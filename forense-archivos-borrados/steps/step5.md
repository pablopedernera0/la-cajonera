# Paso 5 — Cuando el archivo fue sobrescrito

Recuperar un archivo borrado funciona mientras nadie haya escrito encima. La segunda imagen, `dfr-07-fat.dd`, muestra qué pasa cuando sí.

## 5.1 — Lo que hizo NIST

Según el documento de NIST (sección `DFR-07. Recover one overwritten file.` con particiones FAT), en la partición 1 hizo esto, en orden:

| Paso | Acción | Archivos |
|---|---|---|
| 1 | Crear | `XALTIR.TXT`, `XBEID.TXT`, `XCAPH.TXT`, `XDUBHE.TXT`, `XEnif.txt` |
| 2 | Borrar | `XBEID.TXT`, `XCAPH.TXT`, `XDUBHE.TXT` |
| 3 | Crear | `XFURUD.TXT`, `Graffias.TXT` |
| 4 | Borrar | `XFURUD.TXT`, `Graffias.TXT` |

En total, **cinco** archivos borrados en esta partición. Los dos del paso 3 se crearon **después** de borrar los tres primeros, así que el sistema de archivos pudo usar el espacio que había quedado libre.

## 5.2 — ¿Cuántos borrados encontrás?

```bash
cd /root/imagenes
fls -r -d -o 128 dfr-07-fat.dd
```

```
r/r * 5:	_FURUD.TXT
r/r * 7:	Graffias.TXT
```

Aparecen **dos**, no cinco. De `XBEID`, `XCAPH` y `XDUBHE` no queda ni la entrada en el directorio: cuando se crearon los archivos nuevos, el sistema de archivos **reusó** esas entradas libres para anotar los nombres nuevos.

## 5.3 — ¿Y sus datos?

Los datos de un archivo borrado podrían seguir en el disco aunque su entrada ya no exista. Buscá el texto que NIST puso adentro de cada archivo, en **todo** el disco, byte por byte:

```bash
for n in XALTIR XBEID XCAPH XDUBHE XFURUD Graffias XEnif; do
  printf "%-9s %s\n" $n $(grep -a -c "File $n" dfr-07-fat.dd)
done
```

```
XALTIR    1
XBEID     0
XCAPH     0
XDUBHE    0
XFURUD    1
Graffias  1
XEnif     1
```

Los archivos que existen o fueron borrados al final aparecen; los tres que fueron sobrescritos, **no están en ningún lugar del disco**.

## 5.4 — Comprobar dónde se pisaron

Mirá qué sectores ocupaban los dos archivos nuevos:

```bash
istat -o 128 dfr-07-fat.dd 5 | grep -A2 Sectors
istat -o 128 dfr-07-fat.dd 7 | grep -A1 Sectors
```

`XFURUD` ocupaba los sectores **76 a 91** de la partición, y `Graffias` los **92 a 99**. Esos números son relativos al comienzo de la partición. Para pasarlos a sectores del disco se les suma el offset (128):

```bash
echo "XFURUD:   $((76 + 128)) a $((91 + 128))"
echo "Graffias: $((92 + 128)) a $((99 + 128))"
```

Ahora compará con la tabla de sobrescrituras que publica NIST para esta partición:

```
XBEID.TXT x XFURUD.TXT: overlap - 204 - 211
XCAPH.TXT x XFURUD.TXT: overlap - 212 - 219
Graffias.TXT x XDUBHE.TXT: overlap - 220 - 227
```

Coincide exactamente: `XFURUD` se escribió encima de `XBEID` y `XCAPH`, y `Graffias` encima de `XDUBHE`.

## 5.5 — Lo que sí se puede recuperar

```bash
icat -o 128 dfr-07-fat.dd 5 > /root/recuperados/XFURUD.TXT
icat -o 128 dfr-07-fat.dd 7 > /root/recuperados/Graffias.TXT
wc -c /root/recuperados/XFURUD.TXT /root/recuperados/Graffias.TXT
```

Los dos archivos borrados al final se recuperan completos (8192 y 4096 bytes, igual que en NIST): nada se escribió encima de ellos.

> **La lección práctica:** cada minuto que un equipo sigue en uso después de un incidente, aumenta la chance de que se sobrescriba justo lo que hacía falta. Por eso, en un caso real, se evita seguir usando el equipo y se hace la imagen forense lo antes posible.

> Si comprobaste que los sectores de NIST coinciden con los tuyos, estás listo para continuar.

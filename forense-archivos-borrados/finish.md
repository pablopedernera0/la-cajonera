# ¡Escenario completado!

## Lo que hiciste

- Verificaste la **integridad** de dos imágenes de disco de NIST con SHA-256, al principio y al final.
- Leíste la **tabla de particiones** y encontraste una partición cuya etiqueta (FAT12) no coincide con su sistema de archivos real (FAT16).
- Encontraste archivos **borrados** y viste qué conserva FAT de ellos: tamaño, fechas y sectores, pero no la primera letra del nombre corto.
- **Recuperaste** su contenido completo, y lo comprobaste con las marcas de comienzo y final que puso NIST en cada archivo.
- Comprobaste, sector por sector, que los archivos **sobrescritos** no dejan rastro, y que coincide con lo que documenta NIST.

## Comandos clave para recordar

| Comando | Para qué |
|---|---|
| `sha256sum archivo` | Calcular el hash de un archivo |
| `sha256sum -c registro` | Verificar archivos contra un registro de hashes |
| `mmls imagen` | Ver la tabla de particiones |
| `fsstat -o <offset> imagen` | Ver qué sistema de archivos hay en una partición |
| `fls -r -o <offset> imagen` | Listar archivos, incluidos los borrados (`*`) |
| `fls -r -d -o <offset> imagen` | Listar solo los borrados |
| `istat -o <offset> imagen <entrada>` | Ver tamaño, fechas y sectores de una entrada |
| `icat -o <offset> imagen <entrada>` | Recuperar el contenido de un archivo borrado |
| `blkcat -o <offset> imagen <sector>` | Ver el contenido de un sector |

## Conceptos clave

- **Imagen forense:** copia exacta, bit a bit, de un disco, incluido el espacio libre.
- **Hash:** huella de un archivo; si cambia un bit, cambia el hash. Prueba que la evidencia no se modificó.
- **Cadena de custodia:** registro de quién tuvo la evidencia, cuándo y para qué, desde que se obtiene hasta que se presenta.
- **Offset:** sector donde empieza una partición; las herramientas lo necesitan para leer su sistema de archivos.
- **Archivo borrado:** entrada marcada como libre; sus datos siguen en el disco hasta que se sobrescriben.
- **Sobrescritura:** cuando un archivo nuevo ocupa el espacio de uno borrado; lo pisado no se puede recuperar.

## Para pensar

1. ¿Por qué el hash de las imágenes no cambió en todo el análisis? ¿Qué acción lo habría cambiado?
2. La tabla de particiones decía FAT12 y el sistema de archivos era FAT16. ¿Qué te enseña eso sobre confiar en etiquetas?
3. Acá sabías que los archivos recuperados estaban completos porque NIST publicó cómo eran. En un caso real no hay respuesta de referencia: ¿cómo podrías darte cuenta de que un archivo recuperado está incompleto o mezclado con otro?
4. En `dfr-07-fat.dd` se borraron cinco archivos y solo encontraste dos. ¿Qué habría pasado si, después de borrar, no se hubiera creado ningún archivo nuevo?
5. ¿Por qué es importante dejar de usar un equipo lo antes posible después de un incidente?

## Para seguir

- Resumen de forense digital, con principios, marco legal y recursos gratuitos: [pablopedernera0.github.io/forense-digital](https://pablopedernera0.github.io/forense-digital/)
- Todas las imágenes de la serie Deleted File Recovery de NIST (FAT, NTFS, ext, exFAT): [cfreds-archive.nist.gov/dfr-test-images.html](https://cfreds-archive.nist.gov/dfr-test-images.html)

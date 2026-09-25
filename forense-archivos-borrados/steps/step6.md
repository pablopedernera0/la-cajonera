# Paso 6 — Cerrar el análisis

Un análisis forense no termina cuando se encuentra lo que se buscaba: termina cuando se puede demostrar que la evidencia no cambió y que otra persona puede repetir el trabajo.

## 6.1 — Verificar la evidencia al final

```bash
cd /root/imagenes
sha256sum -c hashes.sha256
```

```
dfr-01-fat.dd: OK
dfr-07-fat.dd: OK
```

Todas las herramientas de este escenario (`mmls`, `fsstat`, `fls`, `istat`, `icat`, `blkcat`) **solo leen** la imagen. Nunca se montó el disco, y lo recuperado se guardó en otra carpeta. Por eso el hash es el mismo que al principio.

## 6.2 — Hashes de lo recuperado

Lo que recuperaste también es evidencia, y también lleva hash:

```bash
cd /root/recuperados
ls -l
sha256sum * | tee /root/recuperados.sha256
```

Con ese registro, cualquiera puede comprobar más adelante que los archivos que entregás son los mismos que recuperaste.

## 6.3 — Las herramientas y su versión

```bash
icat -V
```

El resultado de una recuperación puede depender de la herramienta, de su versión y de sus opciones. Por eso un informe siempre dice qué se usó, en qué versión y con qué parámetros, para que otra persona pueda repetirlo.

## 6.4 — Tu informe

Armá un informe breve con tus hallazgos. Podés usar esta estructura:

| Sección | Qué va |
|---|---|
| Evidencia | Nombre de cada imagen y su hash SHA-256, al inicio y al final del análisis |
| Herramientas | The Sleuth Kit, con la versión de `icat -V` |
| Particiones | Tabla de `mmls`: offsets y tipos, y la diferencia entre la etiqueta de la partición 1 (FAT12) y su sistema de archivos real (FAT16) |
| Archivos borrados en `dfr-01-fat.dd` | Nombre, partición, tamaño, si se recuperó completo, y con qué comando |
| Archivos sobrescritos en `dfr-07-fat.dd` | Cuáles no se pudieron recuperar y por qué, con los sectores que lo prueban |
| Comparación con NIST | Qué coincidió con el documento oficial y qué no |
| Limitaciones | La incertidumbre de las fechas en FAT, y lo que no se pudo recuperar |

> Si las dos imágenes siguen dando `OK`, completaste la práctica. Pasá a la reflexión final.

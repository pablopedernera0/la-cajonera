# Forense: recuperar archivos borrados con imágenes de NIST

Cuando se borra un archivo, en la mayoría de los sistemas de archivos sus datos **no desaparecen**: se marca como borrada su entrada en el índice y su espacio queda disponible. Hasta que otro archivo ocupe ese lugar, los datos siguen en el disco.

En esta práctica lo vas a comprobar sobre imágenes de disco reales, con las herramientas que se usan en forense digital.

## ¿De dónde salen las imágenes?

Del **NIST** (el instituto de estándares de Estados Unidos), que publica en su proyecto **CFReDS** (*Computer Forensic Reference Data Sets*) imágenes de disco armadas a propósito para practicar y para probar herramientas forenses. Usamos dos de la serie ***Deleted File Recovery***:

| Imagen | Qué tiene |
|---|---|
| `dfr-01-fat.dd` | Tres particiones FAT; en cada una se borró **un** archivo |
| `dfr-07-fat.dd` | Tres particiones FAT; se borraron archivos y **después se escribieron otros encima** |

Lo bueno de estas imágenes es que NIST **publica cómo las armó**: qué archivos creó, cuáles borró, cuánto medían y en qué sectores estaban. Vas a poder comparar lo que encuentres con las respuestas oficiales, en el documento [Test Images layout](https://cfreds-archive.nist.gov/dfr-images/setup-july-10-2012.pdf) (en inglés).

## ¿Qué vamos a hacer?

Al finalizar esta práctica vas a haber:

- Verificado la **integridad** de la evidencia con un hash SHA-256, antes y después del análisis
- Recorrido la **tabla de particiones** y los **sistemas de archivos** de una imagen sin montarla
- Encontrado archivos **borrados** y **recuperado** su contenido
- Visto qué queda (y qué no) cuando un archivo borrado fue **sobrescrito**
- Comparado tus resultados con las **respuestas oficiales** de NIST

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá el setup. Hacé clic en el comando de abajo y se corre solo en la terminal (Killercoda no deja nada preparado por su cuenta, así que este paso es obligatorio):

`bash /root/setup.sh`{{exec}}

El script instala **The Sleuth Kit** (un conjunto de herramientas libres de análisis forense), descarga las dos imágenes de NIST y registra sus hashes. Tarda alrededor de un minuto.

Cuando termine vas a ver un resumen con las imágenes disponibles. Si todo está bien, continuá con el **Paso 1**.

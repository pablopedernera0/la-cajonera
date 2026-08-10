# Análisis de logs con herramientas de línea de comandos

En las últimas tres prácticas generamos carga, reconocimiento, fuerza bruta e inyección SQL contra esta infraestructura. Ahora nos toca el rol contrario: llegar "un lunes a la mañana" y tener que reconstruir, solo mirando los logs, qué pasó.

## ¿Qué vamos a hacer?

El `setup.sh` de esta práctica no solo levanta la infraestructura: además genera tráfico real (uso normal, un pico de carga, una fuerza bruta y algunos intentos de inyección SQL) para que tengamos evidencia real que investigar, sin depender de que hayas hecho las prácticas anteriores en esta misma sesión.

Al finalizar esta práctica vas a haber:

- Encontrado un pico de carga en los logs de acceso de la app, solo mirando timestamps
- Distinguido un patrón de fuerza bruta por la relación entre intentos fallidos y exitosos
- Habilitado y leído el **general query log** de MySQL — la única fuente que revela el contenido exacto de una consulta SQL, incluida una inyectada
- Armado una línea de tiempo del incidente combinando ambas fuentes

Todo esto con herramientas que ya conocés: `grep`, `awk`, `sort`, `uniq`.

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá este comando:

```bash
bash /root/setup.sh
```

Además de levantar Nginx + MySQL + PhpMyAdmin + la app Flask, el script genera el tráfico que vamos a analizar. Puede tardar un par de minutos.

Cuando termine, vas a ver un resumen con los servicios disponibles y dónde están los logs. Si todo está bien, continuá con el **Paso 1**.

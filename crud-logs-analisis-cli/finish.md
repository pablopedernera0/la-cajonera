# ¡Escenario completado!

Reconstruiste, solo con logs y línea de comandos, la evidencia de un pico de carga, una fuerza bruta y una inyección SQL contra esta infraestructura.

## Lo que hiciste

- **Log de acceso de la app** — identificaste un pico de carga agrupando peticiones por timestamp con `awk` y `uniq -c`
- **Patrón de fuerza bruta** — distinguiste una ráfaga de intentos fallidos seguida de un éxito, por volumen y por agrupamiento temporal
- **`general_log` de MySQL** — habilitaste (ya lo hizo el `setup.sh`) y leíste el registro de cada consulta SQL ejecutada, encontrando el texto exacto de la inyección
- **Correlación de fuentes** — armaste una línea de tiempo combinando dos logs que, por separado, cuentan solo una parte de la historia

## Comandos clave para recordar

| Comando | Para qué sirve |
|---------|----------------|
| `awk -F'[][]' '{print $2}'` | Extraer el texto entre corchetes (el timestamp) de una línea de log |
| `sort \| uniq -c \| sort -rn` | Contar repeticiones y ordenar de mayor a menor — la forma más rápida de ver un pico |
| `SET GLOBAL general_log = 'ON';` | Habilitar el registro de cada consulta SQL en MySQL |
| `grep -- "-- "` | Buscar un patrón que empieza con un guion, sin que `grep` lo confunda con una opción |

## Conceptos clave

**Log de acceso** — registra la interacción HTTP (método, ruta, estado), no el contenido de lo que se envió.

**`general_log`** — registra el contenido exacto de cada consulta SQL. Muy costoso para dejar prendido siempre; muy valioso para investigar puntualmente.

**Correlación de logs** — ninguna fuente de log individual suele contar la historia completa; un incidente real se reconstruye cruzando varias.

## 📮 Antes de seguir: mini-reporte de la etapa

Mandanos un mensaje corto (mail al docente o la plataforma de la materia) con:

1. La salida de `grep -- "-- " /var/lib/mysql/general.log` con la línea de la inyección.
2. En 2-3 líneas: ¿por qué el `general_log` de MySQL no está prendido por defecto, y por qué fue la única fuente que permitió confirmar el contenido exacto de la inyección (a diferencia del log de acceso de la app)?

No suma nota — es un checkpoint para confirmar que la etapa quedó entendida antes de pasar a la siguiente.

## Próximo paso

Todo lo que hiciste hoy fue manual: ir a buscar un archivo, filtrarlo, contar líneas. En la próxima práctica vamos a automatizar esa parte con **Prometheus y Grafana** — métricas y alertas en tiempo real, en vez de logs que hay que revisar después de que ya pasó todo.

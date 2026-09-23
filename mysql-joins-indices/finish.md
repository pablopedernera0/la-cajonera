# ¡Escenario completado!

Recorriste una base MySQL desde phpMyAdmin, consultaste tablas relacionadas con JOINs, y mediste con tus propios números cómo un índice bien elegido convierte una búsqueda de segundos en una de milisegundos, y cómo uno mal elegido no cambia nada.

## Lo que hiciste

- **phpMyAdmin**: estructura de tablas, datos, la pestaña SQL y el tiempo de cada consulta
- **SQL básico**: `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `COUNT` y `GROUP BY`
- **JOIN**: juntaste tablas relacionadas por clave foránea, con `INNER JOIN` (solo filas con pareja) y `LEFT JOIN` (todas las de la izquierda)
- **Ejercicios de JOIN**: totales por cliente, productos sin ventas, y conteos sobre un padrón de 3 millones de personas
- **Índices**: pasaste de revisar 3 millones de filas a revisar una, y de 5 logins en más de 15 segundos a 5 logins en una fracción de segundo
- **Límites de los índices**: `LIKE '%...%'`, el espacio que ocupan y cuándo hace falta un índice compuesto

## Comandos clave para recordar

| Comando | Para qué sirve |
|---|---|
| `SELECT ... FROM ... WHERE ... ORDER BY ...` | Leer filas filtradas y ordenadas |
| `SELECT col, COUNT(*) FROM ... GROUP BY col` | Contar (o sumar, promediar) por grupo |
| `FROM a INNER JOIN b ON b.id = a.b_id` | Juntar dos tablas, solo filas con pareja |
| `FROM a LEFT JOIN b ON ... WHERE b.id IS NULL` | Encontrar filas de `a` que no tienen pareja en `b` |
| `EXPLAIN SELECT ...` | Ver el plan de una consulta sin ejecutarla |
| `CREATE INDEX nombre ON tabla (col1, col2)` | Crear un índice simple o compuesto |
| `DROP INDEX nombre ON tabla` | Borrar un índice |

## Conceptos clave

**Clave primaria**: la columna que identifica cada fila sin repetirse (`id`). MySQL le crea un índice automáticamente.

**Clave foránea**: una columna que apunta a la clave primaria de otra tabla (`pedidos.cliente_id` → `clientes.id`). Es lo que se usa en el `ON` de un JOIN.

**Recorrido completo** (`type: ALL`): MySQL lee todas las filas de la tabla. Con pocas filas no importa; con millones, es la diferencia entre una app que responde y una que no.

**Índice**: una copia ordenada de una o más columnas que permite ir directo a las filas buscadas. Acelera las lecturas, ocupa espacio y hace más lentas las escrituras.

**Selectividad**: qué tanto descarta un filtro. Un email descarta todo menos una fila (muy selectivo); un apellido entre 40 posibles descarta poco. Los índices rinden sobre filtros selectivos.

## Mini-reporte

Mandá un mensaje corto (mail al docente o la plataforma de la materia) con:

1. La salida de `bash /root/buscar_lote.sh 5` **sin** índice y **con** índice sobre `email`.
2. Tu tabla del Paso 6 completa (tiempos, `rows` y el índice que creaste en cada caso).
3. Tus respuestas a las dos preguntas del final del Paso 6.

No suma nota: es un checkpoint para confirmar que la práctica quedó entendida.

## Relación con la materia

Cuando una aplicación anda lenta, la primera reacción suele ser "hace falta un servidor más grande". En esta práctica viste que la misma consulta, sobre el mismo servidor, pasó de más de 15 segundos a milisegundos **sin agregar ni un CPU**: el problema no era de capacidad, era de cómo se buscaban los datos. Antes de dimensionar hacia arriba, conviene mirar el `EXPLAIN`.

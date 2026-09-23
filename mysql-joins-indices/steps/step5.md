# Paso 5 — Índices: de segundos a milisegundos

Imaginá que el padrón es la base de usuarios de una aplicación, y que cada vez que alguien inicia sesión la app lo busca por su email. Vamos a medir cuánto tarda eso, entender por qué, y arreglarlo.

## 5.1 — Medir una búsqueda

En la pestaña **SQL**:

```sql
SELECT * FROM padron WHERE email = 'persona1500007@correo.com.ar';
```

Aparece una sola persona (Tomás Luna). Mirá arriba del resultado cuánto tardó:

```
Mostrando filas 0 - 0 (total de 1, La consulta tardó 1,6359 segundos.)
```

Tu número va a ser distinto, pero del mismo orden: **más de un segundo para encontrar una fila**. Anotalo.

## 5.2 — ¿Por qué tarda? EXPLAIN

Anteponé `EXPLAIN` a la misma consulta:

```sql
EXPLAIN SELECT * FROM padron WHERE email = 'persona1500007@correo.com.ar';
```

`EXPLAIN` no ejecuta la consulta: muestra el **plan** que MySQL va a seguir para resolverla. Mirá estas columnas:

| Columna | Valor | Qué significa |
|---|---|---|
| `type` | `ALL` | Recorrido completo: va a leer **todas** las filas de la tabla |
| `key` | `NULL` | No hay ningún índice que pueda usar |
| `rows` | casi 3 millones | Cuántas filas estima que va a tener que revisar |

Para encontrar un email, MySQL lee los 3 millones de filas una por una y compara. Es como buscar un número en una guía telefónica **desordenada**: no hay otra forma que leerla entera.

> El valor de `rows` es una **estimación** a partir de estadísticas de la tabla, no una cuenta exacta. Por eso puede decir 2.763.638 o 3.061.032 en lugar de 3.000.000.

## 5.3 — Un login no es una sola consulta

Un segundo y medio parece tolerable. Pero una app no busca a un solo usuario: busca a **cada uno que inicia sesión**. En la terminal, simulá 10 logins seguidos:

```bash
bash /root/buscar_lote.sh 10
```

```
Simulando 10 logins contra un padrón de 3000000 personas (SIN índice sobre email)...
  Tiempo total:       15,81 segundos
  Promedio por login: 1581,3 milisegundos
```

**Más de 15 segundos para 10 usuarios.** Si esos 10 llegan al mismo tiempo, el último espera todo eso con la pantalla de carga. Anotá tu tiempo total.

## 5.4 — Crear un índice

Un **índice** es una estructura aparte que MySQL mantiene **ordenada** por una columna (un árbol B), con un puntero a cada fila. Es la guía telefónica ordenada alfabéticamente: para encontrar a alguien vas directo a la letra, no leés todo.

```sql
CREATE INDEX idx_email ON padron (email);
```

**Esto sí tarda** (varios segundos): MySQL tiene que leer los 3 millones de emails y ordenarlos. Pero se hace **una sola vez**; después el índice se actualiza solo con cada `INSERT`, `UPDATE` o `DELETE`.

Si querés verlo desde la interfaz: tabla `padron` → pestaña **Estructura** → sección **Índices**. Ahora hay dos: `PRIMARY` (el de la clave primaria, que MySQL crea siempre) e `idx_email`.

## 5.5 — Medir de nuevo

Repetí la misma búsqueda del 5.1:

```sql
SELECT * FROM padron WHERE email = 'persona1500007@correo.com.ar';
```

El tiempo cae a milésimas de segundo. Mirá el plan:

```sql
EXPLAIN SELECT * FROM padron WHERE email = 'persona1500007@correo.com.ar';
```

| Columna | Antes | Ahora |
|---|---|---|
| `type` | `ALL` | `ref` (busca por índice) |
| `key` | `NULL` | `idx_email` |
| `rows` | casi 3 millones | `1` |

De revisar 3 millones de filas a revisar **una**. Y ahora los logins:

```bash
bash /root/buscar_lote.sh 10
bash /root/buscar_lote.sh 1000
```

Los 10 logins bajan de más de 15 segundos a una fracción de segundo, y 1000 logins tardan menos de lo que tardaba **uno** sin índice.

## 5.6 — Lo que el índice NO arregla

Un índice ordenado sirve cuando sabés **cómo empieza** lo que buscás. Compará estas dos consultas (con `EXPLAIN` y ejecutándolas):

```sql
-- Empieza con...: el índice sirve
SELECT COUNT(*) FROM padron WHERE email LIKE 'persona15000%';

-- Contiene...: el índice no sirve para ubicarse
SELECT COUNT(*) FROM padron WHERE email LIKE '%77777%';
```

| Consulta | `type` | `rows` | Por qué |
|---|---|---|---|
| `LIKE 'persona15000%'` | `range` | ~100 | Va directo al tramo ordenado que empieza así |
| `LIKE '%77777%'` | `index` | casi 3 millones | El `%` inicial puede ser cualquier cosa: tiene que revisar todas las entradas |

En la guía telefónica: encontrar a todos los que empiezan con "Gonz" es fácil; encontrar a todos los que tienen "ález" **en el medio** te obliga a leerla entera. En el segundo caso MySQL recorre el índice en vez de la tabla (es más chico, así que algo gana), pero sigue revisando los 3 millones.

## 5.7 — Los índices no son gratis

Si los índices son tan buenos, ¿por qué no indexar todas las columnas? Mirá cuánto ocupa el que acabás de crear:

```sql
ANALYZE TABLE padron;

SELECT ROUND(data_length / 1024 / 1024)  AS datos_mb,
       ROUND(index_length / 1024 / 1024) AS indices_mb
FROM information_schema.tables
WHERE table_schema = 'practica' AND table_name = 'padron';
```

Un solo índice sobre `email` ocupa **cerca de la mitad** de lo que ocupa la tabla entera (unos 127 MB contra 272 MB). Además, cada vez que se inserta, modifica o borra una fila, MySQL tiene que actualizar **cada uno** de los índices de la tabla: más índices, escrituras más lentas.

La regla práctica: **indexar las columnas por las que la aplicación busca seguido** (el email del login, el DNI en una ventanilla), no todas por las dudas.

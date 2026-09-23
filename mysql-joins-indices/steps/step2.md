# Paso 2 — SQL básico: SELECT, WHERE, ORDER BY y GROUP BY

**SQL** es el lenguaje con el que se le pide cosas a una base de datos. Una consulta de lectura siempre tiene la misma forma, y se lee casi como una oración:

```
SELECT  columnas           -- qué quiero ver
FROM    tabla              -- de dónde
WHERE   condición          -- cuáles filas (opcional)
ORDER BY columna           -- en qué orden (opcional)
```

Escribí cada consulta de este paso en la pestaña **SQL** de phpMyAdmin (con la base `practica` seleccionada) y compará tu resultado con el que se indica.

## 2.1 — Elegir columnas

`*` significa "todas las columnas". Para ver solo algunas, se nombran separadas por coma:

```sql
SELECT nombre, precio FROM productos;
```

## 2.2 — Filtrar filas con WHERE

```sql
SELECT nombre, precio
FROM productos
WHERE precio > 50000;
```

Deberían aparecer 4 productos: la notebook, el monitor, el router y el teclado. Las condiciones se combinan con `AND` (se tienen que cumplir las dos) y `OR` (alcanza con una):

```sql
SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'Redes' AND precio < 50000;
```

Da 2 productos: el switch y el cable. Los textos van entre comillas simples (`'Redes'`); los números, sin comillas.

## 2.3 — Ordenar con ORDER BY y limitar con LIMIT

```sql
SELECT nombre, precio
FROM productos
ORDER BY precio DESC
LIMIT 3;
```

`DESC` ordena de mayor a menor (`ASC`, el valor por defecto, de menor a mayor). `LIMIT 3` se queda con las primeras 3 filas: el resultado son los tres productos más caros.

## 2.4 — Contar y agrupar con GROUP BY

`COUNT(*)` cuenta filas:

```sql
SELECT COUNT(*) FROM clientes;
```

Da `8`. La parte interesante viene al combinarlo con `GROUP BY`, que junta las filas que tienen el mismo valor en una columna y calcula algo **por cada grupo**:

```sql
SELECT ciudad, COUNT(*) AS cantidad
FROM clientes
GROUP BY ciudad
ORDER BY cantidad DESC;
```

| ciudad | cantidad |
|---|---|
| Rosario | 3 |
| Funes | 2 |
| Santa Fe | 1 |
| Casilda | 1 |
| Rafaela | 1 |

`AS cantidad` le pone nombre a la columna calculada, así se puede usar en el `ORDER BY`. Además de `COUNT`, están `SUM` (suma), `AVG` (promedio), `MIN` y `MAX`:

```sql
SELECT categoria, COUNT(*) AS cantidad, MIN(precio), MAX(precio)
FROM productos
GROUP BY categoria;
```

## 2.5 — Lo mismo, sobre 3 millones de filas

Las mismas consultas funcionan igual sobre una tabla enorme. ¿Cuántas personas hay en el padrón por cada localidad?

```sql
SELECT localidad_id, COUNT(*) AS personas
FROM padron
GROUP BY localidad_id
ORDER BY localidad_id;
```

Fijate cuánto tardó (arriba del resultado): para contar, MySQL tuvo que recorrer las 3 millones de filas. Y el resultado tiene un problema: dice `localidad_id` 1, 2, 3… pero **no dice qué localidad es cada número**. Los nombres están en otra tabla, `localidades`. Para juntar las dos hace falta un JOIN, que es el tema del próximo paso.

## Probá vos

1. Listá los clientes de Rosario, ordenados por apellido.
2. ¿Cuántos productos hay en la categoría Periféricos?
3. En el padrón, ¿cuántas personas se apellidan Pérez?

<details>
<summary>Ver soluciones</summary>

```sql
-- 1: López, Pérez y Sosa (en ese orden)
SELECT nombre, apellido FROM clientes WHERE ciudad = 'Rosario' ORDER BY apellido;

-- 2: 3 productos
SELECT COUNT(*) FROM productos WHERE categoria = 'Periféricos';

-- 3: 74.703 personas
SELECT COUNT(*) FROM padron WHERE apellido = 'Pérez';
```

</details>

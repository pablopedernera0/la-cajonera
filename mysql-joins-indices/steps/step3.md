# Paso 3 — JOIN: consultar varias tablas a la vez

En el Paso 1 viste que `pedidos` guarda números (`cliente_id`, `producto_id`) en lugar de nombres. Eso evita repetir datos: si un cliente cambia de apellido, se corrige en **una** fila de `clientes`, no en cada uno de sus pedidos. El costo es que para mostrar un pedido "legible" hay que ir a buscar el nombre a otra tabla. Eso es un **JOIN**.

## 3.1 — La relación entre las tablas

```
 clientes                 pedidos                          productos
┌────┬────────┐   ┌────┬────────────┬─────────────┐   ┌────┬───────────────┐
│ id │ nombre │   │ id │ cliente_id │ producto_id │   │ id │ nombre        │
├────┼────────┤   ├────┼────────────┼─────────────┤   ├────┼───────────────┤
│  1 │ Juan   │◄──│  1 │     1      │      1      │──►│  1 │ Notebook 14"  │
│  2 │ María  │   │  2 │     1      │      2      │   │  2 │ Mouse inal.   │
│ .. │ ...    │   │ .. │    ...     │     ...     │   │ .. │ ...           │
└────┴────────┘   └────┴────────────┴─────────────┘   └────┴───────────────┘
```

`pedidos.cliente_id` apunta a `clientes.id`, y `pedidos.producto_id` apunta a `productos.id`. A una columna que apunta a la clave primaria de otra tabla se la llama **clave foránea** (*foreign key*).

## 3.2 — INNER JOIN: juntar dos tablas

```sql
SELECT pedidos.id, clientes.nombre, clientes.apellido, pedidos.fecha
FROM pedidos
INNER JOIN clientes ON clientes.id = pedidos.cliente_id;
```

Leído en voz alta: "traeme los pedidos, y a cada uno pegale el cliente **cuyo `id` coincida** con el `cliente_id` del pedido". La condición que va después de `ON` es la que dice cómo se relacionan las filas.

Deberían salir **14 filas**, una por pedido, cada una con el nombre de quien lo hizo.

## 3.3 — Alias: escribir menos

Repetir `clientes.` y `pedidos.` en cada columna se vuelve largo. Se puede dar un nombre corto a cada tabla (un **alias**) y usarlo en toda la consulta:

```sql
SELECT pe.id, c.nombre, c.apellido, pe.fecha
FROM pedidos pe
INNER JOIN clientes c ON c.id = pe.cliente_id;
```

Es exactamente la misma consulta. A partir de acá usamos alias.

## 3.4 — Tres tablas a la vez

Los JOIN se encadenan. Para ver quién compró qué, y calcular el subtotal de cada pedido:

```sql
SELECT pe.id, c.apellido, p.nombre AS producto,
       pe.cantidad, p.precio,
       pe.cantidad * p.precio AS subtotal
FROM pedidos pe
INNER JOIN clientes  c ON c.id = pe.cliente_id
INNER JOIN productos p ON p.id = pe.producto_id
ORDER BY pe.id;
```

Las primeras filas:

| id | apellido | producto | cantidad | precio | subtotal |
|---|---|---|---|---|---|
| 1 | Pérez | Notebook 14" | 1 | 850000.00 | 850000.00 |
| 2 | Pérez | Mouse inalámbrico | 2 | 18500.00 | 37000.00 |
| 3 | Gómez | Switch 8 puertos | 1 | 45000.00 | 45000.00 |
| 4 | Gómez | Cable UTP Cat6 (3m) | 10 | 4500.00 | 45000.00 |

## 3.5 — ¿Y los que no tienen pareja? LEFT JOIN

Ahora al revés: partamos de los clientes y peguémosle sus pedidos.

```sql
SELECT c.nombre, c.apellido, pe.id AS pedido
FROM clientes c
INNER JOIN pedidos pe ON pe.cliente_id = c.id
ORDER BY c.id;
```

Contá los clientes que aparecen: son 7, pero la tabla `clientes` tiene 8. **Falta Laura Paz**, porque nunca hizo un pedido. El `INNER JOIN` solo muestra las filas que encontraron pareja en las dos tablas.

Cambiá `INNER JOIN` por `LEFT JOIN`:

```sql
SELECT c.nombre, c.apellido, pe.id AS pedido
FROM clientes c
LEFT JOIN pedidos pe ON pe.cliente_id = c.id
ORDER BY c.id;
```

Ahora salen 15 filas, y Laura aparece con `NULL` en la columna `pedido`. El `LEFT JOIN` conserva **todas** las filas de la tabla de la izquierda (la que está en el `FROM`), tengan pareja o no; donde no hay pareja, completa con `NULL`.

```
        INNER JOIN                          LEFT JOIN
  solo filas con pareja            todas las de la izquierda
                                   (+ su pareja, o NULL)

   clientes    pedidos              clientes    pedidos
   ┌──────┐   ┌──────┐              ┌──────┐   ┌──────┐
   │      │███│      │              │██████│███│      │
   │      │███│      │              │██████│███│      │
   └──────┘   └──────┘              └──────┘   └──────┘
```

## 3.6 — El truco para encontrar "los que no tienen"

Si el `LEFT JOIN` completa con `NULL` a quienes no tienen pareja, alcanza con filtrar esos `NULL` para encontrarlos:

```sql
SELECT c.nombre, c.apellido
FROM clientes c
LEFT JOIN pedidos pe ON pe.cliente_id = c.id
WHERE pe.id IS NULL;
```

Resultado: solo Laura Paz. Ojo, se escribe `IS NULL`: `= NULL` no funciona en SQL (nunca es verdadero).

Este patrón responde preguntas muy comunes: clientes que nunca compraron, productos que nunca se vendieron, usuarios que nunca iniciaron sesión. Lo vas a usar en los ejercicios del próximo paso.

> Existe también `RIGHT JOIN`, que conserva todas las filas de la tabla de la **derecha**. Es lo mismo que un `LEFT JOIN` con las tablas dadas vuelta, así que en la práctica casi siempre se escribe `LEFT JOIN`.

# Paso 4 — Ejercicios de JOIN

Resolvé cada ejercicio en la pestaña **SQL** de phpMyAdmin. Intentá primero sin mirar la solución: el resultado esperado está al lado del enunciado, así podés verificar solo si tu consulta es correcta.

Si te trabás, volvé al Paso 3: todos los ejercicios usan algo de lo que se vio ahí.

## Ejercicio 1 — El listado de pedidos

Listá todos los pedidos con la **fecha**, el **apellido** del cliente, el **nombre del producto** y la **cantidad**, ordenados por fecha.

**Resultado esperado:** 14 filas. La primera es del 2026-08-03 (Pérez, Notebook 14", 1) y la última del 2026-09-15 (Pérez, Monitor 24", 1).

<details>
<summary>Ver solución</summary>

```sql
SELECT pe.fecha, c.apellido, p.nombre AS producto, pe.cantidad
FROM pedidos pe
INNER JOIN clientes  c ON c.id = pe.cliente_id
INNER JOIN productos p ON p.id = pe.producto_id
ORDER BY pe.fecha;
```

</details>

## Ejercicio 2 — ¿Cuánto gastó cada cliente?

Mostrá cada cliente con el **total** que gastó (suma de cantidad × precio de todos sus pedidos), del que más gastó al que menos.

**Resultado esperado:** 7 filas. Encabeza Juan Pérez con 1.097.000 y cierra Martín Sosa con 80.500.

<details>
<summary>Ver solución</summary>

```sql
SELECT c.nombre, c.apellido, SUM(pe.cantidad * p.precio) AS total
FROM clientes c
INNER JOIN pedidos   pe ON pe.cliente_id = c.id
INNER JOIN productos p  ON p.id = pe.producto_id
GROUP BY c.id, c.nombre, c.apellido
ORDER BY total DESC;
```

Es un JOIN (para juntar cantidad y precio) más un `GROUP BY` (para sumar por cliente). Son 7 y no 8 porque Laura Paz no tiene pedidos: el `INNER JOIN` la deja afuera.

</details>

## Ejercicio 3 — Lo más vendido en Redes

Para cada producto de la categoría **Redes**, mostrá cuántas **unidades** se vendieron en total.

**Resultado esperado:** Cable UTP Cat6 (3m) 20, Switch 8 puertos 3, Router Wi-Fi 6 2.

<details>
<summary>Ver solución</summary>

```sql
SELECT p.nombre, SUM(pe.cantidad) AS unidades
FROM productos p
INNER JOIN pedidos pe ON pe.producto_id = p.id
WHERE p.categoria = 'Redes'
GROUP BY p.id, p.nombre
ORDER BY unidades DESC;
```

</details>

## Ejercicio 4 — El producto que nadie compró

Hay un producto que **nunca se vendió**. Encontralo con una consulta (no a ojo).

**Resultado esperado:** Webcam HD.

<details>
<summary>Ver solución</summary>

```sql
SELECT p.nombre
FROM productos p
LEFT JOIN pedidos pe ON pe.producto_id = p.id
WHERE pe.id IS NULL;
```

Es el mismo patrón del Paso 3.6 (`LEFT JOIN` + `IS NULL`), con productos en lugar de clientes.

</details>

## Ejercicio 5 — Clientes de Rosario que compraron equipos de red

¿Qué clientes **de Rosario** compraron algún producto de la categoría **Redes**? Cada cliente tiene que aparecer una sola vez.

**Resultado esperado:** Pedro López.

<details>
<summary>Ver solución</summary>

```sql
SELECT DISTINCT c.nombre, c.apellido
FROM clientes c
INNER JOIN pedidos   pe ON pe.cliente_id = c.id
INNER JOIN productos p  ON p.id = pe.producto_id
WHERE c.ciudad = 'Rosario' AND p.categoria = 'Redes';
```

`DISTINCT` elimina las filas repetidas: sin él, un cliente que compró dos productos de Redes aparecería dos veces.

</details>

## Ejercicio 6 — El padrón, con nombres de localidad

Volvé a la consulta del Paso 2.5, pero ahora mostrando el **nombre** de cada localidad en lugar de su número, de la que tiene más personas a la que tiene menos.

**Resultado esperado:** 20 filas, cada una con unas 150.000 personas. Rosario tiene 150.471.

<details>
<summary>Ver solución</summary>

```sql
SELECT l.nombre, COUNT(*) AS personas
FROM padron pa
INNER JOIN localidades l ON l.id = pa.localidad_id
GROUP BY l.id, l.nombre
ORDER BY personas DESC;
```

</details>

## Ejercicio 7 — Personas por departamento

Cada localidad pertenece a un **departamento** de la provincia (columna `departamento` de `localidades`). ¿Cuántas personas del padrón hay por departamento?

**Resultado esperado:** 10 filas. Encabeza Rosario con 898.858 (junta seis localidades).

<details>
<summary>Ver solución</summary>

```sql
SELECT l.departamento, COUNT(*) AS personas
FROM padron pa
INNER JOIN localidades l ON l.id = pa.localidad_id
GROUP BY l.departamento
ORDER BY personas DESC;
```

La única diferencia con el ejercicio anterior es por qué columna se agrupa. Fijate cuánto tardó: estos dos ejercicios recorren las 3 millones de filas del padrón, y se nota. Para contar a **todos** no queda otra que recorrer todo. Pero cuando buscás **a una persona** entre 3 millones, recorrer todo es un desperdicio, y ahí es donde entra el próximo paso.

</details>

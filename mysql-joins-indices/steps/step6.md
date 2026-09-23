# Paso 6 — Práctica integradora

Ahora te toca a vos, con menos guía. La municipalidad usa el padrón en dos lugares y los dos andan lentos. Para cada caso: **medí, mirá el plan con `EXPLAIN`, proponé un índice, crealo y volvé a medir**.

Armá una tabla con tus números a medida que avanzás: la vas a necesitar para el mini-reporte del final.

| Caso | Tiempo sin índice | `rows` sin índice | Índice creado | Tiempo con índice | `rows` con índice |
|---|---|---|---|---|---|
| A — DNI | | | | | |
| B — Apellido en localidad | | | | | |

## Caso A — La ventanilla busca por DNI

En la ventanilla de atención, el empleado busca a cada vecino por su DNI:

```sql
SELECT * FROM padron WHERE dni = 48555433;
```

Tiene que aparecer Tomás Luna, de nuevo. Medí el tiempo, mirá el `EXPLAIN`, y resolvelo.

<details>
<summary>Ver solución</summary>

```sql
CREATE INDEX idx_dni ON padron (dni);
```

Es el mismo caso del Paso 5, con un número en lugar de un texto: `type` pasa de `ALL` a `ref`, y `rows` de casi 3 millones a `1`. Los índices funcionan igual sobre columnas numéricas y de texto.

</details>

## Caso B — ¿Cuántos Pérez hay en Rosario?

El área de estadística necesita saber cuántas personas de un apellido viven en una localidad. Para Pérez en Rosario:

```sql
SELECT COUNT(*)
FROM padron p
INNER JOIN localidades l ON l.id = p.localidad_id
WHERE p.apellido = 'Pérez' AND l.nombre = 'Rosario';
```

**Resultado esperado:** 3709. Medí el tiempo y mirá el `EXPLAIN`.

**Primer intento.** Parece razonable indexar el apellido:

```sql
CREATE INDEX idx_apellido ON padron (apellido);
```

Volvé a medir y a mirar el `EXPLAIN`. ¿Mejoró? ¿Cuántas filas dice `rows` para `padron`?

<details>
<summary>Ver qué pasó</summary>

Casi no mejora; incluso puede tardar un poco más. El `EXPLAIN` muestra que MySQL usa `idx_apellido`, pero con `rows` cercano a 150.000: el índice lo lleva directo a **todos los Pérez de la provincia** (unos 75.000; `rows` es una estimación), y después tiene que ir a buscar cada una de esas filas a la tabla para ver en qué localidad viven. Saltar 75.000 veces de un lado a otro sale casi tan caro como leer todo en orden.

Un índice sirve cuando **descarta la mayor parte** de la tabla. Con 40 apellidos posibles, cada apellido es el 2,5% del padrón: todavía demasiadas filas.

</details>

**Segundo intento.** Borrá ese índice y creá uno **compuesto**, sobre las dos columnas por las que filtra la consulta:

```sql
DROP INDEX idx_apellido ON padron;
CREATE INDEX idx_apellido_localidad ON padron (apellido, localidad_id);
```

Medí de nuevo y mirá el `EXPLAIN`.

<details>
<summary>Ver qué pasó</summary>

El tiempo cae a milésimas y `rows` baja a unos pocos miles (la estimación de los 3709 Pérez de Rosario). Además, en `Extra` aparece `Using index`: todo lo que la consulta necesita (apellido y localidad) está **dentro** del índice, así que MySQL ni siquiera tiene que ir a leer la tabla.

Un índice compuesto se ordena primero por la primera columna y, dentro de cada valor, por la segunda, como una guía ordenada por apellido y, dentro de cada apellido, por localidad. Para "Pérez en Rosario" va directo al tramo exacto.

</details>

## Para pensar

Antes de pasar al final, respondé con tus palabras:

1. En el caso B, ¿por qué el índice sobre `apellido` solo no alcanzó, si el del email en el Paso 5 funcionó tan bien?
2. Si la tabla `padron` recibiera miles de altas por minuto, ¿crearías los tres índices de esta práctica (email, DNI y apellido + localidad)? ¿Qué mirarías para decidir?

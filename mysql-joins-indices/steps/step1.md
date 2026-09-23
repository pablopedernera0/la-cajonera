# Paso 1 — Recorrida por phpMyAdmin

**phpMyAdmin** es una aplicación web para administrar MySQL desde el navegador: ver tablas, cargar datos y ejecutar consultas sin usar la terminal. Es muy común encontrarla en hostings y servidores compartidos, así que conviene saber moverse en ella.

## 1.1 — Abrir phpMyAdmin

phpMyAdmin está escuchando en el puerto 8080. Abrilo con este enlace:

[Abrir phpMyAdmin]({{TRAFFIC_HOST1_8080}})

Si el enlace no funciona, usá el menú de Killercoda (arriba a la derecha) → **Traffic / Ports** → puerto **8080**.

El setup configuró phpMyAdmin para entrar directo como `root`, sin pedirte usuario ni contraseña. En un servidor real **nunca** se deja así: es cómodo para practicar, y un agujero de seguridad en producción.

## 1.2 — Encontrar la base de la práctica

En el panel de la izquierda está la lista de bases de datos. Hacé clic en **`practica`**: se despliegan sus seis tablas.

Las bases `information_schema`, `mysql`, `performance_schema` y `sys` son de MySQL mismo (usuarios, permisos, estadísticas). No las toques.

## 1.3 — Ver la estructura de una tabla

Hacé clic en la tabla **`pedidos`** y después en la pestaña **Estructura**. Vas a ver cada columna con su tipo:

| Columna | Tipo | Qué guarda |
|---|---|---|
| `id` | `int` | Número de pedido. Es la **clave primaria**: identifica cada fila, no se repite |
| `cliente_id` | `int` | El `id` del cliente que hizo el pedido |
| `producto_id` | `int` | El `id` del producto que se pidió |
| `cantidad` | `int` | Cuántas unidades |
| `fecha` | `date` | Cuándo |

Fijate que `pedidos` **no guarda el nombre del cliente ni del producto**: guarda solo sus números de `id`. Los nombres están en las tablas `clientes` y `productos`. Esa es la idea central de una base relacional, y en el Paso 3 vas a ver cómo se vuelven a juntar con un JOIN.

## 1.4 — Ver los datos

Pasá a la pestaña **Examinar**: muestra las filas de la tabla. Mirá también `clientes` y `productos`, así ya los conocés antes de consultarlos.

Ahora abrí **`padron`** y hacé clic en **Examinar**. Aunque tiene 3 millones de filas, aparece enseguida: phpMyAdmin pide solo las primeras 25 (agrega un `LIMIT` a la consulta). Mirar la primera página es rápido; **buscar** algo adentro, como vas a ver en el Paso 5, es otra historia.

## 1.5 — La pestaña SQL

Con la base `practica` seleccionada, entrá a la pestaña **SQL**. Es un cuadro de texto donde escribís una consulta y la ejecutás con el botón **Continuar**. Probá:

```sql
SELECT * FROM clientes;
```

Arriba del resultado, phpMyAdmin te dice cuántas filas trajo y **cuánto tardó la consulta**, por ejemplo:

```
Mostrando filas 0 - 7 (total de 8, La consulta tardó 0,0004 segundos.)
```

Ese tiempo es el que vas a usar para medir en el Paso 5. A partir de ahora, todas las consultas de la práctica las escribís en esta pestaña.

> **¿Preferís la terminal?** Todo lo que hagas en la pestaña SQL también se puede hacer desde la consola de MySQL:
>
> ```bash
> docker exec -it mysql mysql --default-character-set=utf8mb4 -uroot -pmysecretpassword practica
> ```
>
> Cada consulta termina en `;`, y para salir se escribe `exit`.

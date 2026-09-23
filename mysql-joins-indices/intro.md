# MySQL con phpMyAdmin: SQL básico, JOINs e índices

Casi toda aplicación que despliegues va a tener una base de datos atrás: la app CRUD que vienen usando en la materia guarda sus datos en MySQL. Desde infraestructura no alcanza con levantar el contenedor: cuando la app anda lenta, muchas veces el problema no es el servidor ni la red, sino **cómo está consultando la base**. Esta práctica te da las herramientas para mirar adentro.

## ¿Qué vamos a hacer?

Al finalizar esta práctica vas a haber:

- Recorrido una base MySQL desde **phpMyAdmin**: tablas, estructura, datos y la pestaña SQL
- Escrito consultas básicas: filtrar (`WHERE`), ordenar (`ORDER BY`), contar y agrupar (`GROUP BY`)
- Entendido qué es un **JOIN** y la diferencia entre `INNER JOIN` y `LEFT JOIN`
- Resuelto ejercicios de JOIN sobre una tienda chica, y uno sobre un padrón de 3 millones de personas
- Medido con tus propios números cuánto tarda una búsqueda **sin índice** y **con índice**
- Usado `EXPLAIN` para ver cómo piensa MySQL una consulta antes de ejecutarla

## Los datos

La base se llama `practica` y tiene dos grupos de tablas:

| Tablas | Filas | Para qué |
|---|---|---|
| `clientes`, `productos`, `pedidos` | 8, 8 y 14 | Aprender SQL y JOINs: son tan chicas que podés verificar cada resultado a ojo |
| `localidades`, `padron` | 20 y 3.000.000 | Medir: el padrón es lo bastante grande como para que la diferencia sin/con índice se note |

> Todas las personas del padrón son **inventadas**: el setup las genera al azar (nombres, DNI, emails). No hay datos reales de nadie.

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá el setup para levantar toda la infraestructura. Hacé clic en el comando de abajo y se corre solo en la terminal (Killercoda no deja nada corriendo por su cuenta, así que este paso es obligatorio):

`bash /root/setup.sh`{{exec}}

El script levanta MySQL y phpMyAdmin con Docker Compose, crea las tablas de la tienda y genera el padrón de 3 millones de personas. **Puede tardar unos minutos**: la mayor parte es generar el padrón.

Cuando termine, vas a ver un resumen con los servicios disponibles y una línea como esta:

```
✓ Una búsqueda por email tarda 3.37 segundos en esta máquina
```

Anotá ese número: es tu primera medición, y en el Paso 5 lo vas a comparar. Si todo está bien, continuá con el **Paso 1**.

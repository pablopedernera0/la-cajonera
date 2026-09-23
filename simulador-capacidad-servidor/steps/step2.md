# Paso 2 — Primer cuello de botella: procesos

Corré el primer lote de carga:

```bash
subir_carga.sh
```

Con 1 worker, vas a ver que la mayoría de las 1000 peticiones salen bien (código 200),
pero el **tiempo de respuesta promedio** es alto — bastante más lento que un pedido
normal. Eso es cola: llegan más peticiones de las que el único worker puede atender al
mismo tiempo, así que se van amontonando y cada una espera su turno.

El script te lo va a decir explícitamente al final del resumen, con el comando exacto para
resolverlo. Ejecutalo:

```bash
sumar_cpu.sh
```

Confirmá el cambio:

```bash
curl http://localhost:8080/status
```

Deberías ver más workers que al principio. Con eso resuelto, seguí al Paso 3 — pero
guardate el número de tiempo de respuesta promedio de este lote, lo vas a necesitar en el
Paso 5.

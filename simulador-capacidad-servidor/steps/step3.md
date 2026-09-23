# Paso 3 — Segundo cuello de botella: memoria

Corré otro lote, ya con los workers de más:

```bash
subir_carga.sh
```

La latencia va a estar bien esta vez — el problema de procesos ya lo resolviste. Pero
ahora vas a ver algo distinto: un montón de peticiones **fallando** directamente (código
distinto de 200), no solo tardando más. Ese es un problema diferente: al servidor no le
faltan procesos para atender, le falta memoria para sostener la cola de peticiones que
todavía no procesó, así que empieza a rechazarlas.

Es la misma lección que ya viste en los casos reales: **agregar la capacidad que no es el
cuello de botella no arregla nada.** Si hubieras vuelto a sumar procesos acá, no habría
cambiado nada — el límite real era otro.

El script te lo señala igual que antes. Resolvelo:

```bash
sumar_ram.sh
```

Guardate el porcentaje de peticiones fallidas de este lote — también lo vas a necesitar
en el Paso 5.

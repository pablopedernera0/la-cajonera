# Paso 4 — Confirmar que ya aguanta la carga

Con los dos cuellos de botella resueltos, corré un tercer lote:

```bash
subir_carga.sh
```

Esta vez el resumen debería mostrar las 1000 peticiones exitosas, sin fallas, y con un
tiempo de respuesta bajo — el mensaje final tiene que decir que el servidor está
aguantando bien la carga.

Mirá el estado final del servidor:

```bash
curl http://localhost:8080/status
```

Ahí queda el resumen completo de lo que pasó: cuántas peticiones procesó en total desde
que arrancó, y cuántas de esas fallaron — la cuenta incluye los lotes anteriores, así que
el número de fallidas no va a ser cero, aunque el último lote haya salido perfecto. Es
información acumulada, igual que un panel de monitoreo real.

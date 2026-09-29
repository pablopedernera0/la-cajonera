# Paso 6 (optativo) — Una página web sobre el mismo modelo

`app.py` es una página web mínima con Flask. No tiene lógica propia: importa `entrenar()` y
`generar()` de `markov.py`, los mismos del Paso 1.

```bash
cd /root/generador-markov-python
grep -n "import\|entrenar(\|generar(" app.py
```

## Levantarla

La corremos en segundo plano, para seguir usando esta terminal:

```bash
nohup python3 app.py > app.log 2>&1 &
sleep 2 && cat app.log
```

Ábranla: [Generador de Markov en el puerto 5000]({{TRAFFIC_HOST1_5000}}).

Elijan un texto y un largo de contexto y toquen **Generar**. Debajo aparecen las filas de
la tabla que tienen más de una continuación posible: los únicos lugares donde el modelo
realmente sortea.

## Cambiar el modelo

El servidor corre con recarga automática: al guardar `markov.py`, se reinicia solo.
Cambiemos cómo elige la palabra siguiente: en lugar de sortear, que elija **siempre la
continuación más frecuente**.

```bash
sed -i 's/random.choice(tabla\[contexto\])/max(set(tabla[contexto]), key=tabla[contexto].count)/' markov.py
grep -n "max(set" markov.py
```

(Si prefieren hacerlo a mano: `nano markov.py`, en la función `generar()`.)

El log muestra que el servidor se reinició:

```bash
tail -3 app.log
```

Recarguen la página y generen varias veces con `hechos` y 2 de contexto. Ahora solo varía
el comienzo, que sigue siendo al azar. Lo demás es siempre igual, y cae en bucles: la
misma continuación más frecuente lleva otra vez al mismo lugar. Por ejemplo, «En la
provincia de Mendoza se produce mucho azúcar.» repetida hasta el final (en un empate,
cuál gana puede cambiar de una corrida a otra). Es lo que muestra la opción «Siempre la
más frecuente» de la versión web.

Para volver al original:

```bash
git checkout markov.py
```

## Lo que muestra

La página y el modelo son dos cosas separadas: el modelo es la tabla y las dos funciones
de `markov.py`; la página solo le pide texto y lo muestra. En chiquito, es la relación
entre un modelo de lenguaje y la aplicación que lo usa: un asistente de chat es una
aplicación montada sobre un modelo.

Para apagar el servidor:

```bash
pkill -f app.py
```

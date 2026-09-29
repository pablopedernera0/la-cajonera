# Paso 1 — El texto y el código: contar y sortear

Entren a la carpeta del generador:

```bash
cd /root/generador-markov-python
```

## El texto de partida

```bash
cat textos/hechos.txt
```

Quince oraciones de geografía argentina, **todas verdaderas**. El encabezado (`nombre:`,
`pista:`, la línea `---`) es para la página web; el script lo saltea.

## Entrenar

```bash
sed -n '/^def palabras/,/^def generar/p' markov.py
```

`palabras()` separa el texto en palabras y signos de puntuación: el punto cuenta como una
palabra más, y así el modelo "aprende" dónde terminan las oraciones.

`entrenar()` es un solo `for`: para cada posición toma las *n* palabras (el **contexto**,
como tupla, para que sirva de clave de diccionario) y agrega a su lista la palabra que vino
después. Si una continuación apareció tres veces, queda tres veces en la lista.

## Generar

```bash
sed -n '/^def generar/,/^def unir/p' markov.py
```

Arranca con un contexto que sigue a un punto (un comienzo de oración) y repite: mira las
últimas *n* palabras, las busca en la tabla y hace `random.choice` sobre la lista.

Como la lista guarda cada aparición con sus repetidos, `random.choice` ya sortea con peso:
lo que vino más veces sale más seguido. No hace falta calcular probabilidades.

Si el contexto no está en la tabla, el modelo **se traba** y corta: nunca vio esa
secuencia y no tiene con qué seguir.

## Probarlo

```bash
python3 markov.py textos/hechos.txt
```

Córranlo varias veces: cada corrida sortea distinto.

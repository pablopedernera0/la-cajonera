# Paso 2 — La tabla es el modelo entero

Con `tabla` como tercer argumento, el script imprime lo que aprendió en vez de generar.
Probemos con otro texto:

```bash
cat textos/oficios.txt
```

```bash
python3 markov.py textos/oficios.txt 2 tabla
```

Cada fila es un contexto de dos palabras y, a la derecha, qué vino después y cuántas veces.
Las filas con más opciones aparecen primero. **Eso es todo lo que el modelo "sabe"**: no
hay nada más escondido.

Cuenten cuántas filas tienen una sola continuación posible (en esas no hay nada que
sortear: el modelo repite el texto):

```bash
python3 markov.py textos/oficios.txt 2 tabla | wc -l
python3 markov.py textos/oficios.txt 2 tabla | grep -c ", '"
```

La primera cifra es el total de filas; la segunda, las que tienen más de una opción.

## Lo que no está

Busquen qué puede seguir después de «La»:

```bash
python3 markov.py textos/oficios.txt 2 tabla | grep "^. La "
```

```bash
python3 markov.py textos/oficios.txt 2 tabla | grep -i "ingeniera"
```

La segunda búsqueda no devuelve nada. Ninguna oración del texto dice que no haya
ingenieras ni enfermeros: simplemente **no aparecen**, y el modelo no puede generar lo que
nunca contó. Es la forma más cruda de un sesgo en los datos de entrenamiento, y se ve
entera en una tabla de setenta filas.

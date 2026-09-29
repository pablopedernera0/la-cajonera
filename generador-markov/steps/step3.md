# Paso 3 — Cuánto contexto mirar

El segundo argumento es *n*, cuántas palabras mira el modelo para decidir la siguiente.
Generen cinco veces con cada valor:

```bash
for i in 1 2 3 4 5; do python3 markov.py textos/hechos.txt 1; echo; done
```

```bash
for i in 1 2 3 4 5; do python3 markov.py textos/hechos.txt 2; echo; done
```

```bash
for i in 1 2 3 4 5; do python3 markov.py textos/hechos.txt 3; echo; done
```

- **Con 1**, mira una sola palabra: tropieza, se repite y encadena fragmentos sin
  gramática.
- **Con 2**, casi todo suena bien. Busquen una oración **gramatical y falsa**, como
  «Paraná es la montaña más alta de América.»: el texto de partida era todo verdadero, y
  el modelo solo pegó tramos que sí aparecieron. Verifiquen de dónde viene cada tramo:

  ```bash
  grep -n -e "Paraná es la" -e "es la montaña más alta" textos/hechos.txt
  ```

  La costura está en «es la»: en el texto la siguió «capital» cuatro veces y «montaña» una,
  y esta vez el sorteo eligió la menos frecuente.

  ```bash
  python3 markov.py textos/hechos.txt 2 tabla | grep "^es la "
  ```

- **Con 3**, largos tramos son oraciones del texto tal cual. Los cruces aparecen poco, y
  solo donde tres palabras seguidas se repiten en oraciones distintas (como «en la
  provincia»).

## Por qué pasa

Miren cuántas filas tiene la tabla y cuántas tienen una sola continuación:

```bash
for n in 1 2 3; do
  echo "n=$n: $(python3 markov.py textos/hechos.txt $n tabla | wc -l) filas," \
       "$(python3 markov.py textos/hechos.txt $n tabla | grep -vc ", '") con una sola opción"
done
```

Con este texto da 56 filas y 38 sin opciones con *n* = 1, y 111 y 104 con *n* = 3. Cuanto
más largo el contexto, más filas y menos opciones en cada una: con poco texto, cada
contexto de tres palabras apareció una sola vez, y el modelo no tiene más remedio que
**copiar**. Más contexto da más coherencia, pero hace falta muchísimo más texto para que
no se convierta en copia.

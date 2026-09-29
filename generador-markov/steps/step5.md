# Paso 5 — El control anti-copia

En el Paso 3 vimos que con mucho contexto y poco texto, lo generado es copia del original.
markovify lo controla por defecto: descarta una oración generada si repite textualmente un
tramo del original de más del **70 % de su largo** o de más de **15 palabras**, y vuelve a
intentar.

```bash
python3 -c "import markovify.text as t; print(t.DEFAULT_MAX_OVERLAP_RATIO, t.DEFAULT_MAX_OVERLAP_TOTAL)"
```

El modo `copias` genera 300 versos sin ese control y 300 con el control, y cuenta cuántos
son un verso del poema tal cual:

```bash
sed -n '/^def contar_copias/,/^if __name__/p' con_markovify.py
```

## Con dos palabras de contexto

```bash
python3 con_markovify.py textos/martin-fierro.txt 2 copias
```

Sin el control, más de la mitad de los versos son copia textual del poema. Con el control,
ninguno.

## Con tres

```bash
python3 con_markovify.py textos/martin-fierro.txt 3 copias
```

Sin el control, casi todo es copia. Con el control, markovify casi nunca encuentra algo
que devolver: en 300 intentos (de 10 pruebas cada uno) entrega unas pocas decenas de versos.
Cuando cada contexto de tres palabras apareció una sola vez en el poema, **lo único que el
modelo sabe hacer es copiar**, y el control lo único que puede hacer es callarlo.

Los números cambian un poco entre corridas porque cada corrida sortea distinto.

## Para pensar con estudiantes

Un modelo que genera texto nuevo y uno que devuelve pedazos de su texto de entrenamiento
son **el mismo modelo** con distinto balance entre contexto y cantidad de datos. Esa
tensión (y el problema de qué hacer cuando el modelo reproduce textualmente lo que leyó)
existe también en los modelos de lenguaje actuales, a otra escala.

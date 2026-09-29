# Paso 4 — markovify y el Martín Fierro

[markovify](https://github.com/jsvine/markovify) es una biblioteca que hace lo mismo que
`markov.py`, con algunos agregados. Para probarla hace falta un texto más grande que
quince oraciones:

```bash
wc -l textos/martin-fierro.txt
sed -n '4,15p' textos/martin-fierro.txt
```

La primera parte de *El gaucho Martín Fierro* (José Hernández, 1872, dominio público),
un verso por línea.

## El código

```bash
sed -n '/^def modelo/,/^def contar_copias/p' con_markovify.py
```

`markovify.NewlineText` toma cada línea como una unidad (una "oración") y arma la misma
tabla de contexto → siguiente. `state_size` es nuestro *n*. `make_sentence()` genera una
unidad completa, de comienzo a fin.

## Generar estrofas

```bash
python3 con_markovify.py
```

Seis versos generados con dos palabras de contexto. Córranlo varias veces. Suenan a gaucho
porque todo lo que pueden decir salió del poema; lo que no tienen es rima, métrica ni
sentido de estrofa: cada verso se genera por separado, sin mirar el anterior.

Con tres palabras de contexto:

```bash
python3 con_markovify.py textos/martin-fierro.txt 3
```

Algunas líneas dicen *(no encontró nada que no fuera copia del texto original)*. No es un
error: es el control anti-copia de markovify, que es el tema del paso siguiente.

# Un modelo de lenguaje a mano

Un generador de Markov hace, en chico, la tarea de un modelo de lenguaje: **predecir la
palabra que sigue**. Lo hace de la forma más simple posible:

- **Entrenar es contar.** Recorre un texto y anota, para cada secuencia de *n* palabras,
  qué palabra vino después y cuántas veces.
- **Generar es sortear.** Mira las últimas *n* palabras que escribió, busca esa secuencia
  en la tabla y sortea la siguiente entre las que vinieron después en el texto, con más
  chances para las más frecuentes.

Este escenario es la versión en código del generador web
[pablopedernera0.github.io/generador-markov](https://pablopedernera0.github.io/generador-markov/).
Van a leer y correr:

| Archivo | Qué es |
|---|---|
| `markov.py` | El generador completo en Python puro, sin bibliotecas. Unas treinta líneas. |
| `con_markovify.py` | La misma idea con [markovify](https://github.com/jsvine/markovify), sobre *El gaucho Martín Fierro*. |
| `app.py` | Una página web mínima con Flask que usa `markov.py` (Paso 6, optativo). |
| `textos/` | Los textos de partida de la página web y el poema de Hernández. |

El código está en [github.com/pablopedernera0/generador-markov-python](https://github.com/pablopedernera0/generador-markov-python):
lo pueden clonar y usar con sus estudiantes.

## Antes de empezar

Preparen el entorno: instala `pip`, clona el repositorio en `/root/generador-markov-python`
e instala `markovify` y Flask. Tarda menos de un minuto.

`bash /root/setup.sh`{{exec}}

Cuando termine van a ver **Entorno listo**.

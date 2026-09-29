# Terminaron

Vieron un modelo de lenguaje entero, de punta a punta:

- **Entrenar es contar** qué palabra vino después de cada secuencia de *n* palabras.
- **La tabla es el modelo**: lo que no está en el texto de partida no puede aparecer en lo
  generado (Paso 2).
- **Generar es sortear** la palabra siguiente con peso según las veces. De ahí salen
  oraciones gramaticales y falsas armadas con tramos verdaderos (Paso 3).
- **Más contexto** da más coherencia, pero con poco texto termina en copia; markovify la
  filtra, y cuando todo sería copia se queda sin nada que decir (Pasos 4 y 5).

## Lo que este generador no es

Un modelo de lenguaje actual hace **la misma tarea** (predecir lo que sigue) con **otra
maquinaria**:

- Trabaja con fragmentos de palabras, no con palabras enteras.
- Mira miles de fragmentos hacia atrás, no una, dos o tres palabras.
- No busca el contexto exacto en una tabla: una red neuronal le permite responder ante
  contextos que nunca vio, parecidos a otros que sí vio. La tabla de `markov.py`, en cambio,
  se traba.
- Después de ese entrenamiento tiene otro, que lo ajusta para conversar y seguir
  instrucciones.

## Para seguir

- La versión web, para mostrar en clase sin terminal:
  [pablopedernera0.github.io/generador-markov](https://pablopedernera0.github.io/generador-markov/).
  Deja tocar cada palabra generada y ver de qué oración del texto salió.
- El código, para clonar y usar con sus estudiantes:
  [github.com/pablopedernera0/generador-markov-python](https://github.com/pablopedernera0/generador-markov-python).
  Prueben con un texto propio: cualquier `.txt` con una oración o un verso por línea sirve.

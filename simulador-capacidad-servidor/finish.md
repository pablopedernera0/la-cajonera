# ¡Listo!

Rompiste un servidor dos veces, con dos causas distintas, y lo arreglaste las dos veces
con la solución que correspondía a cada una — no con la primera que se te ocurrió.

Eso es dimensionamiento de capacidad: no es "agregar más de todo", es identificar cuál es
el límite real antes de gastar en resolver el que no es.

## Repaso

- Un servidor puede fallar por falta de **procesos** (se nota como latencia alta: las
  peticiones tardan, pero salen bien) o por falta de **memoria** (se nota como fallas
  directas: las peticiones se rechazan).
- Agregar la capacidad equivocada no resuelve nada — hay que mirar los síntomas para saber
  cuál de las dos es.
- Un RNF de capacidad útil tiene números concretos: cuántos usuarios, cuánto tiempo de
  respuesta, qué porcentaje de éxito, y qué pasa si se supera ese límite.

## Para seguir

- Los casos reales de esta misma idea, a escala real: Healthcare.gov, Pokémon Go y Prime
  Day, en `casos-fallidos-dimensionamiento` (pablopedernera0.github.io).
- Si te quedaste con ganas de medir contra servidores reales en vez de un simulador, la
  práctica `medicion-http-servidores` de este mismo repo.

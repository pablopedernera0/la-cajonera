# Kahoot "La noche del incidente" (Etapa 5)

Pieza transmedia sobre `crud-logs-analisis-cli` (Etapa 5, forense de logs), armada para la
actividad opcional "Material propio con tu herramienta" del Taller de Innovación y Diseño de
Materiales Digitales (UCU, Módulo II, vence 2026-09-30). Pablo la eligió como su aporte al
foro del módulo.

Idea transmedia: Killercoda da la terminal; el Kahoot da el relato (reconstruir el incidente
votando en grupo bajo presión de tiempo). La pregunta 10 y el cierre pasan el relato a la
Etapa 6 (Prometheus + Grafana).

Todos los datos salen de la guía de la Etapa 5 y de su `setup.sh`: nada inventado. Todo el
tráfico sale de `127.0.0.1`; si se agrega una "IP atacante" distinta, marcarla como
ficticia. Grafana **no** muestra la fuerza bruta ni la SQLi como tales, solo como algunos
requests más: no armar preguntas que digan lo contrario.

Estado (2026-09-28): este borrador de 10 preguntas convive con otra versión de 12 preguntas,
ya commiteada en el repo del Taller (`entregas/actividad-opcional-1-kahoot`, commit `b7d7273`,
con planilla xlsx e imágenes). Pablo va a elegir una de las dos o combinarlas. Correcciones que
hizo la sesión de la UCU, ya aplicadas acá: el 04/08/2026 cae martes y no lunes, el distractor
de la pregunta 10 y la imagen de la pregunta 6.

---

**Planteo** (pantalla de portada): *"Martes 04/08. Entre las 13:38 y las 13:40, la app
`crud-python` se comportó raro. No hay alarmas, solo dos archivos de log. ¿Qué pasó?"*

| # | Pregunta | Opciones (✔ = correcta) | Tiempo |
|---|---|---|---|
| 1 | El log muestra `60 04/Aug/2026 13:39:35`: 60 pedidos a `/` en el mismo segundo. ¿Qué es? | ✔ Un pico de carga generado por una herramienta · 60 estudiantes entrando a la vez · Una fuerza bruta · Una inyección SQL | 20 s |
| 2 | Los `POST /login` dan `10 × 200` y `4 × 302`. ¿Qué significa el 302? | ✔ Un login exitoso (redirige a `/`) · Un login fallido · Un error del servidor · Una página que no existe | 20 s |
| 3 | Hay varios intentos de login en el mismo segundo, todos con el usuario `admin`. ¿Qué indica? | ✔ Un script que prueba una lista de contraseñas · Alguien que tipea rápido · Un pico de carga · La sesión que expiró | 20 s |
| 4 | Verdadero/Falso: el log de acceso de la app muestra qué contraseña se probó en cada intento. | ✔ Falso · Verdadero | 10 s |
| 5 | ¿Qué fuente muestra la consulta SQL exacta que llegó a la base? | ✔ El `general_log` de MySQL · El log de acceso de Flask · PhpMyAdmin · El historial de bash | 20 s |
| 6 | `WHERE usuario = 'admin' -- ' AND password = 'x'` ¿Qué hace el `-- `? | ✔ Comenta el resto: la contraseña no se chequea · Borra al usuario admin · Da un error de sintaxis · Cifra la contraseña | 30 s |
| 7 | `usuario = 'admin' AND '1'='2'` ¿Entró el atacante con este intento? | ✔ No, es un tanteo: la condición es falsa · Sí, como admin · Sí, como cualquier usuario · Borró la tabla | 30 s |
| 8 | ¿Por qué el `general_log` no viene prendido por defecto? | ✔ Tiene un costo de rendimiento y de disco · Es inseguro · Solo funciona en Windows · Requiere Grafana | 20 s |
| 9 | ¿En qué orden pasó todo? | ✔ Uso normal → pico → fuerza bruta → SQLi · Fuerza bruta → SQLi → pico → normal · Pico → SQLi → normal → fuerza bruta · SQLi → pico → fuerza bruta → normal | 60 s |
| 10 | Puente a la Etapa 6: ¿qué panel de Grafana habría mostrado el pico de las 13:39:35 *mientras pasaba*? | ✔ Requests por segundo · Espacio en disco · Ninguno, solo se ve en logs · El panel de usuarios | 20 s |

**Cierre** (diapositiva final): *"Encontraste todo buscando después en los archivos. La próxima vez,
lo vas a ver mientras pasa."*

Notas de carga:
- Mezclar el orden de las opciones al cargarlas: acá la correcta siempre va primera.
- Kahoot limita las preguntas a 120 caracteres y las respuestas a 75. En la 6, la consulta va
  como imagen (en la versión del Taller ya existe `q07-sqli-admin.png`).
- En la 10 no usar "Conexiones a MySQL" como distractor: en la Etapa 6 ese panel también se
  mueve junto con el tráfico, así que no es claramente incorrecto.
- La 9 sería mejor como tipo "Puzzle" (ordenar), si el plan de Kahoot lo incluye. Sin
  verificar.
- Queda por hacer, si se quiere: generar el `.xlsx` con el formato de la plantilla de
  importación de Kahoot.

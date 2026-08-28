# Trabajo n°7 — Instructivo de despliegue

> Borrador de contenido para el instructivo que reciben los estudiantes. Falta darle
> presentación final (probablemente como página HTML en `pablopedernera0.github.io`,
> siguiendo el patrón de las guías de estudiantes existentes) y completar los datos
> entre corchetes. Este archivo es el contenido, no la entrega final.

## El escenario

Un equipo de desarrollo les entrega una aplicación ya construida y les pide que la
pongan en funcionamiento. Ustedes no escriben una línea de código de la app — reciben
el `Dockerfile` ya armado — y son responsables de todo lo que hace falta alrededor
para que quede corriendo de forma correcta: red, persistencia de datos, configuración,
y la documentación de por qué tomaron cada decisión.

Trabajan en equipo. Cada integrante corre su propia sesión en Killercoda — no hay una
terminal compartida entre compañeros — así que la coordinación del grupo pasa por el
repositorio de GitHub: cada uno prueba en su sesión, y sincronizan por `push`/`pull`.

## Lo que reciben

- El código de la aplicación y su `Dockerfile` ya armado:
  [`pablopedernera0/crud-python`](https://github.com/pablopedernera0/crud-python),
  rama `trabajo7-deploy`.
- El esquema que la base de datos necesita (`init.sql`, en ese mismo repo): crea las
  tablas que usa la app y carga un usuario de prueba para poder iniciar sesión.
  Cómo hacer que ese esquema se aplique al levantar la base es parte de la decisión
  de infraestructura.
- Este instructivo.

Lo que **no** reciben es un `docker-compose.yml` ya armado. Ese es el trabajo.

## Qué tiene que cumplir el despliegue

Esto es lo que se va a evaluar. No hay requisitos ocultos más allá de esta lista.

**Funcionamiento**

1. La aplicación tiene que quedar accesible desde el navegador del host, en un puerto
   conocido.
2. La aplicación tiene que poder conectarse a la base de datos resolviendo por
   nombre de servicio, no por una IP fija.
3. La base de datos tiene que arrancar con el esquema y los datos que la aplicación
   necesita para funcionar.

**Persistencia y configuración**

4. Los datos de la base no se pueden perder si el contenedor se reinicia o se
   recrea.
5. Ninguna credencial ni dato sensible puede estar escrito en el código ni en la
   imagen — tiene que poder cambiarse sin reconstruir nada.

**Documentación y proceso**

6. Cada decisión de infraestructura (por qué esa red, ese volumen, esa forma de
   pasar credenciales) queda documentada y justificada en el repo — no alcanza con
   que funcione, tiene que poder explicarse.
7. El historial de commits refleja el proceso de decisión del equipo: mensajes que
   digan qué se decidió y por qué, no solo qué archivo se tocó.

## Herramientas que vas a necesitar

Estas secciones explican **conceptos** de Docker, no la solución a este despliegue
en particular. Qué servicio necesita cuál herramienta, y cómo aplicarla acá, es
parte de la decisión que tiene que tomar el equipo.

### Persistencia con volúmenes

Para que los datos de un servicio sobrevivan a un reinicio o a que se recree el
contenedor, Docker permite montar **volúmenes**: un espacio de almacenamiento que
vive fuera del ciclo de vida del contenedor. La forma general es:

```yaml
services:
  algun-servicio:
    volumes:
      - nombre_del_volumen:/ruta/dentro/del/contenedor

volumes:
  nombre_del_volumen:
```

Documentación oficial: <https://docs.docker.com/engine/storage/volumes/>

### Redes y resolución por nombre

Cuando varios servicios están definidos en el mismo `docker-compose.yml`, Docker
Compose los conecta automáticamente a una red donde cada uno puede resolver a los
demás **por el nombre del servicio**, sin necesidad de conocer una IP. Documentación
oficial (incluye cómo definir redes propias si hace falta separar servicios):
<https://docs.docker.com/engine/network/>

### Variables de entorno

Para pasar configuración (credenciales, hosts, puertos) sin escribirla en el código
ni en la imagen, los servicios pueden recibir **variables de entorno** definidas en
el `docker-compose.yml`, o cargadas desde un archivo aparte. Documentación oficial:
<https://docs.docker.com/compose/how-tos/environment-variables/>

## Cómo se entrega

- Repositorio en GitHub del equipo, con el `docker-compose.yml` y el historial de
  commits del proceso.
- Un único `README.md` que documente y justifique las decisiones de infraestructura
  tomadas (una sección por requisito de la lista de arriba alcanza como estructura).
- **Fecha de entrega:** [completar].
- **Defensa oral:** [completar — instancia del parcial en la que se revisa lo
  entregado].

## Cómo se corrige

En el parcial se revisa lo ya subido a GitHub y se hacen preguntas puntuales a cada
integrante sobre decisiones tomadas, para confirmar comprensión y aporte individual
dentro del trabajo grupal.

# Stress Testing de una app Flask + MySQL

En la práctica anterior desplegaste a mano Nginx, MySQL, PhpMyAdmin y una app CRUD Flask conectada a la base `alumnos`. Esa misma infraestructura te va a acompañar el resto del cuatrimestre: primero le vamos a medir el aguante con un stress test, más adelante la vamos a atacar, y sobre el final vamos a aprender a monitorearla en tiempo real.

## ¿Qué es un stress test?

Someter una aplicación a **stress testing** significa generarle tráfico artificial —muchas peticiones en poco tiempo o con mucha concurrencia— para responder preguntas muy concretas:

- ¿Cuántas peticiones por segundo puede atender?
- ¿Cuánto tarda en responder cada una?
- ¿En qué punto empieza a fallar o a degradarse?
- ¿Qué componente se satura primero: la app, la base de datos, la red?

## ¿Qué vamos a hacer?

Al finalizar esta práctica vas a haber:

- Generado carga liviana con un loop de **`curl`** contra un endpoint de lectura y uno de escritura
- Comparado el costo de leer contra el costo de escribir en la base de datos
- Entendido por qué el servidor de desarrollo de Flask no escala con concurrencia
- Levantado la misma app con **Gunicorn** (un servidor apto para producción) y comprobado la diferencia

> Esta plataforma (Killercoda) no permite correr herramientas de stress testing reales — no
> es una cuestión de qué tan fuerte sea la carga, prohíben la categoría de herramienta
> completa. Acá vamos a medir con `curl`, que alcanza para entender los conceptos. La prueba
> de carga real (con `ab`, empujando la app hasta que falla) existe aparte, para correr en tu
> propia computadora — tu docente te la va a mostrar en vivo.

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá este comando para levantar toda la infraestructura:

```bash
bash /root/setup.sh
```

El script instala las dependencias, levanta Nginx + MySQL + PhpMyAdmin con Docker Compose, crea la base `alumnos` con datos de ejemplo, y clona y arranca la app Flask en el puerto 8888. Puede tardar un par de minutos.

Cuando termine, vas a ver un resumen con los servicios disponibles. Si todo está bien, continuá con el **Paso 1**.

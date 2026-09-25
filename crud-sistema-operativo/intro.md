# El sistema operativo debajo de la infraestructura

A lo largo del hilo conductor desplegaste una app Flask con MySQL, la mediste con carga, la pasaste de un servidor de desarrollo a **Gunicorn con varios workers**, la metiste en **contenedores** y miraste la **CPU de MySQL** en Prometheus. En cada una de esas prácticas estuvo trabajando alguien de quien casi no hablamos: el **sistema operativo**.

Hoy lo miramos a él. Todo es la misma infraestructura de siempre, pero vista desde abajo.

## ¿Qué vamos a hacer?

Al finalizar esta práctica vas a haber:

- Visto al **kernel** atendiendo las **llamadas al sistema** de un programa común (`cat`, `curl`)
- Recorrido el árbol de **procesos** de Gunicorn, y visto cómo el proceso master reemplaza a un worker que muere
- Contado los **hilos** de MySQL y visto nacer uno por cada conexión nueva
- Distinguido la **memoria virtual** de la memoria real de un proceso, y provocado a propósito al **OOM killer**
- Comprobado que un contenedor **no es una máquina virtual**: es un proceso del host, con **namespaces** (lo que ve) y **cgroups** (lo que puede usar)
- Limitado la CPU de MySQL y medido cómo el **scheduler** la frena, en la terminal y en Prometheus

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá el setup. Hacé clic en el comando de abajo y se corre solo en la terminal (Killercoda no deja nada corriendo por su cuenta, así que este paso es obligatorio):

`bash /root/setup.sh`{{exec}}

El script levanta MySQL, la app Flask servida con **Gunicorn** (1 master + 2 workers), y `cAdvisor` + `Prometheus` para mirar métricas de contenedores. También instala los scripts que vas a usar para generar carga. Puede tardar un par de minutos.

> **Sobre la carga:** en esta práctica toda la carga se genera con scripts ya preparados (`carga_http.sh`, `carga_cpu_mysql.sh`, etc.), con topes fijos de duración e intensidad. La idea es ver al sistema operativo trabajar, no saturar la máquina.

Cuando termine vas a ver un resumen con los servicios y los scripts disponibles. Si todo está bien, continuá con el **Paso 1**.

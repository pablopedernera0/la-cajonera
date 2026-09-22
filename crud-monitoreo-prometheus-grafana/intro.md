# Monitoreo en vivo con Prometheus y Grafana

En la práctica anterior investigamos un incidente **después** de que había pasado, revisando archivos de log a mano con `grep` y `awk`. Hoy cerramos el hilo conductor con el enfoque contrario: instrumentar la infraestructura para ver, **en tiempo real**, qué está pasando.

## ¿Qué vamos a hacer?

Al finalizar esta práctica vas a haber:

- Entendido la diferencia entre logs (eventos) y métricas (series numéricas en el tiempo)
- Levantado **Prometheus** (recolector de métricas) apuntando a la app, a MySQL y a los contenedores Docker
- Armado tu primer dashboard en **Grafana**
- Repetido el stress test de la primera práctica, mirando en vivo cómo reacciona cada componente

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá el setup. Hacé clic en el comando de abajo y se corre solo en la terminal (Killercoda no deja nada corriendo por su cuenta, así que este paso es obligatorio):

`bash /root/setup.sh`{{exec}}

El script levanta MySQL, la app Flask (esta vez con métricas expuestas en `/metrics`), y todo el stack de monitoreo: `cAdvisor` (métricas de contenedores), `mysqld-exporter` (métricas de MySQL), `Prometheus` y `Grafana`. Puede tardar un par de minutos, son varios contenedores.

Cuando termine, vas a ver un resumen con los servicios disponibles. Si todo está bien, continuá con el **Paso 1**.

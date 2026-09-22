# Paso 3 — Grafana: el primer dashboard

## 3.1 — Acceder a Grafana

Hacé click en el ícono **hamburger** (≡) arriba a la derecha, seleccioná **"Traffic / Ports"**, escribí `3000` en **Custom Ports** y hacé click en **Access**.

Ingresá con usuario `admin` y contraseña `admin` (el `setup.sh` la configuró así). Si te pide cambiarla, podés omitirlo.

## 3.2 — Conectar Grafana con Prometheus

1. En el menú lateral, andá a **Connections → Data sources**
2. Click en **Add data source** → elegí **Prometheus**
3. En **Connection → Prometheus server URL**, escribí:

```
http://prometheus:9090
```

Usamos el nombre del servicio (`prometheus`), no `localhost` — Grafana y Prometheus corren en contenedores distintos, conectados por la red de Docker Compose, igual que la app se conecta a MySQL por nombre de servicio.

4. Bajá al final y hacé click en **Save & test**. Debería confirmar que la conexión funciona.

## 3.3 — Crear tu primer panel

1. En el menú lateral (≡) andá a **Dashboards**, y arriba a la derecha click en **New → New dashboard**.
2. Grafana te pregunta el **layout** del tablero: elegí **Auto grid** (ubica y dimensiona los paneles solo).
3. En el panel **Add** de la derecha, click en la tarjeta **Panel** ("Drag or click to add a panel"). Se abre el editor del panel.
4. Arriba a la derecha del editor, en el selector de **fuente de datos**, elegí **Prometheus** (si no quedó seleccionada sola).
5. En el editor de consulta, pegá:

```
rate(flask_http_request_duration_seconds_count[1m])
```

Esto grafica la cantidad de peticiones por segundo que recibe la app, calculada sobre una ventana de 1 minuto. Todavía no va a mostrar mucho — la app casi no tiene tráfico.

6. En las opciones del panel (columna derecha) ponele un **título**, por ejemplo "Requests por segundo". Después, arriba a la derecha, click en **Save dashboard**, ponele un nombre al dashboard y confirmá.

> Nota: la pantalla del dashboard cambia entre versiones de Grafana. Estas instrucciones son para **Grafana 13.2.2** (la que instala el `setup.sh`). En versiones más viejas el botón se llamaba "Add visualization" en vez de la tarjeta "Panel".

## 3.4 — Agregar un segundo panel

Volvé a **Edit** el dashboard, click de nuevo en la tarjeta **Panel** para agregar otro, y usá esta consulta para tener a la vista las conexiones a MySQL:

```
mysql_global_status_threads_connected
```

> Con el dashboard armado (aunque todavía esté "plano"), pasá al Paso 4 para generarle tráfico de verdad y verlo reaccionar en vivo.

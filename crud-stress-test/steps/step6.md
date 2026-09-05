# Paso 6 — Casos reales de dimensionamiento

La carga que generaste en los pasos anteriores fue liviana a propósito — esta plataforma no permite llevar una app a su límite real. Pero el problema que estuviste midiendo (cuánta capacidad hace falta para un tráfico dado) es uno de los más caros de la industria cuando se calcula mal. Antes de calcularlo vos mismo en el Paso 7, veamos qué pasó cuando otros lo calcularon mal — y cuando lo calcularon bien.

## 6.1 — healthcare.gov (2013): probar poco y confiar mucho

El sitio de inscripción al seguro médico de Estados Unidos se lanzó el 1 de octubre de 2013. Antes del lanzamiento, el equipo probó el sistema con unos **2.000 usuarios concurrentes**. El día del lanzamiento llegaron **250.000**. El sitio se cayó a las dos horas.

> Fuente: [NPR — Tech Problems Plague First Day Of Health Exchange Rollout](https://www.npr.org/sections/alltechconsidered/2013/10/02/228220325/tech-problems-plague-first-day-of-health-exchange-rollout)

**Para pensar:** en el Paso 3 de esta práctica viste que con 50 peticiones sueltas el ruido de la medición pesa tanto como la diferencia real entre leer y escribir — no alcanza para ver el problema con confianza. Con 2.000 usuarios simulados pasa algo parecido, pero al revés: el equipo de healthcare.gov *sí* confió en ese número. ¿Por qué probar con 2.000 no te dice nada confiable sobre qué va a pasar con 250.000? (Pensá en qué componentes — red, base de datos, balanceador — se comportan distinto a medida que sube la escala, no solo más lento.)

## 6.2 — Pokémon GO (2016): el margen que faltó

Niantic lanzó Pokémon GO calculando un tráfico esperado (**1x**) y un peor escenario posible de **5x** ese número. El tráfico real el día del lanzamiento fue **50x** — diez veces peor que el peor escenario que habían previsto. El juego se caía constantemente en cada país donde se lanzaba.

Google (proveedor de la infraestructura) armó un equipo de respuesta a este incidente. Para el lanzamiento en Japón, con aprovisionamiento generoso y ajustes de arquitectura hechos a partir de lo aprendido, el juego salió **sin caerse**.

> Fuente: [High Scalability — Case Study: Pokémon GO on Google Cloud Load Balancing](https://highscalability.com/blog/2018/8/8/case-study-pokemon-go-on-google-cloud-load-balancing.html)

**Para pensar:** Niantic subestimó incluso su peor escenario por 10 veces. En el Paso 7 vas a calcular cuántos workers necesitás para un objetivo dado, con un margen de seguridad. ¿Qué margen te parece razonable dejar sobre una estimación — y por qué un margen "generoso" en capacidad cuesta plata todo el tiempo (aunque el pico de tráfico solo llegue una vez al año)?

## 6.3 — Shopify: el mismo cálculo, hecho con meses de anticipación

Shopify prepara su infraestructura para el Black Friday con **meses de anticipación**: modela el tráfico esperado a partir de datos históricos, arma estimaciones de capacidad, y las valida con pruebas de carga reales antes de que llegue el pico (a esa prueba la llaman internamente "Oktoberfest scale-up").

> Fuente: [Shopify Engineering — Capacity Planning at Scale](https://shopify.engineering/capacity-planning-shopify)

**Para pensar:** es el mismo ejercicio que le faltó a healthcare.gov — la diferencia no es la tecnología, es que Shopify *mide* su capacidad real antes de necesitarla, en vez de asumirla.

## 6.4 — Caso abierto: Ticketmaster y la preventa de Taylor Swift (2022)

Cuando salieron a la venta las entradas de la gira Eras Tour, Ticketmaster recibió **3.500 millones de peticiones en un día** — cuatro veces su pico anterior. El sitio colapsó, hubo colas de hasta ocho horas, y terminaron cancelando la venta general.

> Fuente: [Axios — 'Unprecedented' demand for Taylor Swift tour crashes Ticketmaster website](https://www.axios.com/2022/11/15/taylor-swift-tour-presale-tickets-ticketmaster-outage-error)

A diferencia de los casos anteriores, Ticketmaster **nunca publicó un postmortem técnico**. No hay una respuesta oficial para leer.

**Para pensar (sin respuesta correcta):** con los conceptos de throughput, concurrencia y servidor de desarrollo vs. producción que viste en esta práctica, ¿qué hipótesis armarías sobre qué componente se saturó primero? No busques la respuesta en internet — es un ejercicio de razonar con lo que ya sabés, no de investigar qué pasó.

---

Los cuatro casos comparten algo: la diferencia entre un problema evitable y uno inevitable fue, casi siempre, si alguien había hecho el cálculo antes de necesitarlo. En el Paso 7 vas a hacer ese cálculo vos, a escala chica, sobre la misma infraestructura que mediste en los pasos anteriores.

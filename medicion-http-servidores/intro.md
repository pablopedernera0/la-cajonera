# Medición de tiempos de respuesta y tamaño: HTML vs. JSON

En la Clase 1 de Dimensionamiento de Servidores vimos, con datos ya medidos, que una página HTML completa puede pesar **~65 veces más** que un JSON equivalente — y que ese peso es lo que termina definiendo cuánta CPU y ancho de banda necesita un servidor.

Hoy esa medición la hacés vos, con tu propia terminal, contra sitios públicos reales.

## ¿Qué vas a hacer?

Al finalizar esta práctica vas a haber:

- Medido, con `curl`, el tamaño y el tiempo de respuesta de una página HTML completa
- Medido lo mismo contra un backend que solo devuelve JSON
- Comparado ambos resultados con los mismos indicadores que usa cualquier Analista Funcional para dimensionar infraestructura: tamaño de la respuesta, tiempo hasta el primer byte (TTFB) y tiempo total
- Documentado la comparación con tus propios números y una captura de pantalla

No hay que instalar ni configurar nada más allá de correr un script. No vas a editar ningún archivo — todo se hace ejecutando los dos scripts que trae el entorno.

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá este comando para preparar el entorno:

```bash
bash /root/setup.sh
```

El script verifica que `curl` esté disponible y que el entorno tenga salida a internet. Cuando termine, vas a ver un resumen. Si todo está bien, continuá con el **Paso 1**.

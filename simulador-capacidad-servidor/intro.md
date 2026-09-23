# Simulador de capacidad: romper un servidor y arreglarlo

Ya viste qué pasó cuando Healthcare.gov, Pokémon Go y Prime Day no dimensionaron bien su
infraestructura: el sistema se cayó justo cuando más tráfico tenía. Hoy no vas a leer sobre
eso — vas a provocarlo vos mismo, en miniatura, contra un servidor que armamos para esta
práctica.

## ¿Qué vas a hacer?

Al finalizar esta práctica vas a haber:

- Sometido a un servidor simulado a cargas crecientes hasta encontrar **dos** cuellos de
  botella distintos: falta de procesos (CPU) y falta de memoria (RAM)
- Resuelto cada uno con el script que corresponde, y comprobado con tus propios números que
  la solución funcionó
- Visto en vivo, con datos tuyos, la misma idea que ya viste en los casos reales: agregar la
  capacidad equivocada no arregla nada, hay que identificar cuál es el cuello de botella real
- Escrito tu propio requisito no funcional (RNF) de capacidad, con tus números en vez de los
  de un caso ajeno

No hay nada que instalar ni configurar a mano — todo se hace con los scripts que ya trae el
entorno.

## Preparar el entorno

Antes de continuar con el Paso 1, ejecutá este comando para preparar el entorno:

```bash
bash /root/setup.sh
```

El script levanta el servidor simulado en el puerto 8080 y deja disponibles los comandos
`subir_carga.sh`, `sumar_cpu.sh` y `sumar_ram.sh`. Cuando termine, vas a ver un resumen. Si
todo está bien, continuá con el **Paso 1**.

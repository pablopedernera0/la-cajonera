### Visualizando el resultado

¡El entorno está listo! Vamos a verificar que todo funcione correctamente y ver nuestro Markdown renderizado en el navegador.

#### Paso 1: Verificar que el contenedor está corriendo

`docker-compose -f ~/markdown-lab/docker-compose.yml ps`{{exec}}

#### Paso 2: Verificar que el HTML fue generado

`ls -lh ~/markdown-lab/contenido/`{{exec}}

Deberías ver el archivo `documento.md` que editaste. El HTML se sirve desde dentro del contenedor.

#### Paso 3: Probar desde la terminal con curl

Podemos verificar que NGINX está respondiendo correctamente:

`curl -s http://localhost | head -30`{{exec}}

Si ves código HTML en la respuesta, ¡el servidor está funcionando!

#### Paso 4: Abrir en el navegador

En Killercoda, podés acceder al puerto 80 usando el botón **"Traffic / Ports"** en el panel superior, o directamente con la URL que te provee el entorno.

Deberías ver tu documento Markdown renderizado con estilo, con:

- Títulos con jerarquía visual clara
- Tabla de comandos Docker formateada
- Bloques de código con formato monoespaciado
- Separadores horizontales
- Texto en negrita y cursiva

#### Paso 5: Hacer un cambio y ver el resultado

Probá editar el documento y verificá el ciclo completo:

`nano ~/markdown-lab/contenido/documento.md`{{exec}}

Agregá una nueva sección al final, por ejemplo:

```markdown
## Mi primera edición en vivo

Agregué esta sección para probar el ciclo completo de edición.

- Edité con `nano`
- Reinicié el contenedor
- ¡Vi el resultado en el navegador!
```

Guardá con `Ctrl + O`, `Enter`, `Ctrl + X`.

Luego reiniciá el contenedor:

`cd ~/markdown-lab && docker compose restart`{{exec}}

Recargá el navegador y deberías ver tu nueva sección.

#### Paso 6: Ver los logs del contenedor (opcional)

Si algo no funciona como esperás, podés inspeccionar los logs:

`docker-compose -f ~/markdown-lab/docker-compose.yml logs`{{exec}}

Ahí verás el output del script de conversión y cualquier error de NGINX.

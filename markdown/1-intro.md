# Markdown con Docker y NGINX
## Aprendé a escribir y visualizar Markdown en un entorno real
### Autor: "Pablo Pedernera"
### Nivel: "Inicial"

#### ¿De qué trata este escenario?

En este escenario vas a aprender a:

- Escribir documentos en **Markdown**, el lenguaje de marcado más usado en la industria tecnológica
- Usar el editor de texto **nano** directamente desde la terminal
- Levantar un entorno con **Docker** y **Docker Compose** que renderiza Markdown como HTML
- Ver el resultado en tiempo real desde el navegador

#### ¿Por qué Markdown?

Markdown es el formato estándar para documentar proyectos de software, escribir READMEs en GitHub, redactar wikis internas y muchas otras tareas cotidianas en infraestructura y desarrollo. Aprender a escribirlo es una habilidad fundamental para cualquier profesional del área.

#### ¿Qué vamos a construir?

Vamos a levantar un contenedor Docker con NGINX que sirve un **renderizador de Markdown**. Cada vez que editemos nuestro archivo `.md` con nano, al recargar el navegador veremos los cambios reflejados en HTML con formato.

El flujo completo es:

```
nano documento.md  →  Docker (NGINX + renderizador)  →  Navegador
```

¡Empecemos!

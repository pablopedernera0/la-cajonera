### ¿Qué es Markdown?

Markdown es un lenguaje de marcado ligero creado en 2004 por John Gruber. La idea es simple: escribir texto plano con algunas convenciones mínimas que luego se convierten automáticamente en HTML con formato.

A diferencia de un procesador de texto como Word, en Markdown escribís directamente con el teclado sin usar menúes ni botones. Esto lo hace ideal para entornos de terminal, documentación técnica y control de versiones con Git.

#### Sintaxis básica de Markdown

A continuación, las construcciones más usadas:

##### Títulos

Los títulos se crean con el símbolo `#`. Cuantos más `#`, más pequeño el título:

```
# Título nivel 1
## Título nivel 2
### Título nivel 3
```

##### Énfasis de texto

```
**negrita**
*cursiva*
~~tachado~~
```

##### Listas

Listas sin orden (viñetas):

```
- Elemento A
- Elemento B
  - Sub-elemento
```

Listas ordenadas (numeradas):

```
1. Primero
2. Segundo
3. Tercero
```

##### Código

Para código en línea usamos comillas inversas:

```
El comando `docker ps` lista los contenedores activos.
```

Para bloques de código, tres comillas inversas seguidas del lenguaje:

````
```bash
docker run -d -p 80:80 nginx
```
````

##### Enlaces e imágenes

```
[Texto del enlace](https://ejemplo.com)
![Texto alternativo](ruta/imagen.png)
```

##### Tablas

```
| Columna 1 | Columna 2 |
|-----------|-----------|
| Valor 1   | Valor 2   |
```

##### Citas en bloque

```
> Esto es una cita importante.
```

##### Separador horizontal

```
---
```

#### ¿Dónde se usa Markdown?

- `README.md` en repositorios de GitHub y GitLab
- Documentación técnica (MkDocs, Docusaurus, Jekyll)
- Wikis de proyectos (Confluence, Notion, Obsidian)
- Mensajería técnica (Slack, Discord, Mattermost)
- Plataformas de aprendizaje como **Killercoda** (¡este escenario está escrito en Markdown!)

### Enviar cambios al repositorio

Realizar cambios en los archivos del proyecto

`nano primer_archivo.txt`

Dentro de nano agregarle contenido al archivo

Salir de nano presionando `ctrl x` y guardando los cambios presionando luego `Y` y luego  `enter`

Comprobar que el archivo existe y que tiene un tamaño mayor a '0'

`ls -lh`

La salida debería ser similar a esta 

```
ubuntu $ ls -l
total 4
-rw-r--r-- 1 root root 49 Aug 20 11:04 primer_archivo.txt
ubuntu $ 
```
Git tiene un área especial que se llama `staging`, en esa area se van a ir agregando los archivos con cambios que luego serán enviados al repositorio remoto.

Las buenas prácticas indican que nunca debe usarse `git add .`, porque podemos cometer el error de enviar archivos con cambios que no están preparados, siempre es mejor enviar los archivos de a uno usando ` git add <filename>`

Para ver los archivos que tienen cambios, nada mejor que ejecutar `git status`

```
ubuntu $ git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        primer_archivo.txt

nothing added to commit but untracked files present (use "git add" to track)
ubuntu $ 
```

Notemos el color rojo del archivo `primer_archivo.txt`, ese color nos indica que el archivo no está 'preparado' para ser enviado al servidor.

Para agregar un archivo un archivo que tenga cambios al área de `staging`, tal como decíamos más arriba hay que ejecutar

`git add primer_archivo.txt`

Si luego ejecutamos nuevamente `git status`
```
ubuntu $ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   primer_archivo.txt

ubuntu $ 
```

Vemos que ahora el archivo `primer_archivo.txt` está ahora de color verde.

Esto significa que se encuentra en el área de `staging`, casi listo para ser enviado al repositorio remoto.

Antes de poder enviar los cambios, es necesario escribir un mensaje de commit.

El commit es la confirmación de que los cambios queremos efectivamente enviarlos al repositorio.

Para confirmar los cambios y escribir un mensaje descriptivo hay que ejecutar `git commit -m "Mensaje del commit"`.

Si es un repositorio remoto, usamos `git push origin master` para enviar los cambios al repositorio remoto.

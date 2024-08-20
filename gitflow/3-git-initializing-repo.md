### Inicializar un repo

Crea un nuevo directorio para tu proyecto

`mkdir directorio_proyecto`

Comprobar que el directorio se ha creado

`ls -l`

La salida debería ser parecida a esto 

```
ubuntu $ ls -l
total 8
drwxr-xr-x 2 root root 4096 Aug 20 10:58 directorio_proyecto
lrwxrwxrwx 1 root root    1 Aug  2 07:17 filesystem -> /
drwx------ 3 root root 4096 Aug 20 08:22 snap
ubuntu $ 
```


Movernos al directorio recien creado

`cd proyecto_directorio`

Ejecutar git init para inicializar un nuevo repositorio de Git

`git init`

La salida debería ser parecida a esto (puede variar dependiendo de la versión de git instalada en la computadora)

```
ubuntu $ git init
Initialized empty Git repository in /root/directorio_proyecto/.git/
ubuntu $ 
```
# Paso 3 — El general query log de MySQL: la prueba de la inyección

MySQL tiene un modo de log que registra **cada consulta SQL que se ejecuta**, tal cual llega al servidor: el `general_log`. El `setup.sh` de esta práctica ya lo dejó habilitado.

## 3.1 — Confirmar que está prendido

```bash
docker exec $(docker ps -qf "name=mysql") mysql -h 127.0.0.1 -uroot -pmysecretpassword -e "SHOW VARIABLES LIKE 'general_log%';"
```

## 3.2 — Por qué no está prendido por defecto

```bash
docker exec $(docker ps -qf "name=mysql") ls -la /var/lib/mysql/general.log
```

Con apenas un par de minutos de tráfico de prueba, el archivo ya pesa varios KB. Registrar **cada** consulta que ejecuta el servidor tiene un costo real de performance y de espacio en disco — por eso en producción casi nunca está prendido de arranque. Se activa puntualmente cuando hace falta investigar algo, como estamos haciendo ahora.

## 3.3 — Ver todas las consultas del login

```bash
docker exec $(docker ps -qf "name=mysql") grep "usuarios WHERE" /var/lib/mysql/general.log
```

Vas a ver, línea por línea, la consulta exacta que arma `/login` para cada intento — incluidos los de la fuerza bruta del paso anterior, con la contraseña probada en texto plano.

## 3.4 — Buscar la firma de una inyección SQL

```bash
docker exec $(docker ps -qf "name=mysql") grep -- "-- " /var/lib/mysql/general.log
```

Deberías encontrar algo así:

```sql
SELECT id, usuario FROM usuarios WHERE usuario = 'admin' -- ' AND password = 'x'
SELECT id, usuario FROM usuarios WHERE usuario = '' OR '1'='1' -- ' AND password = 'x'
```

Ahí está: a diferencia de la fuerza bruta (que prueba muchas contraseñas contra un `usuario` normal), acá el propio texto de `usuario` reescribe la consulta. El `general_log` es la única de las dos fuentes que lo deja ver — el log de acceso de la app solo mostró un puñado de `POST /login` sueltos, indistinguibles a simple vista de un usuario común.

## 3.5 — Confirmar con otra búsqueda

```bash
docker exec $(docker ps -qf "name=mysql") grep "AND '1'='2" /var/lib/mysql/general.log
```

Este es un intento que **no** llegó a comprometer el login (la condición es falsa), pero tiene la misma firma sospechosa: comillas y operadores SQL donde debería haber solamente un nombre de usuario. Es el tipo de prueba "de tanteo" que suele hacer una herramienta como `sqlmap` antes de encontrar el payload que funciona.

> Con la prueba de la inyección encontrada, en el Paso 4 vamos a ordenar todo esto en una línea de tiempo del incidente completo.

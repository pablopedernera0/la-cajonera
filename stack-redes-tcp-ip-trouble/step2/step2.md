# Paso 2 — Reparar el servidor DNS

En este paso vas a identificar y corregir los errores en la configuración de `named`.

## 2.1 — Analizar los errores de named-checkconf

```
named-checkconf 2>&1
```

Este comando valida la sintaxis de todos los archivos de configuración de named. Si hay un error, te dice exactamente en qué archivo y en qué línea.

## 2.2 — Ver el archivo con errores

```
cat /etc/bind/named.conf.options
```

Analizá la estructura del archivo. Un bloque `options { }` debe tener su llave de apertura y su llave de cierre.

## 2.3 — Reparar named.conf.options

Editá el archivo para corregir el error estructural:

```
nano /etc/bind/named.conf.options
```

El archivo correcto debe verse así:

```
options {
    directory "/var/cache/bind";
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };
    allow-query { any; };
    dnssec-validation no;
    listen-on { any; };
};
```

Guardá con `Ctrl+O`, `Enter`, `Ctrl+X`.

## 2.4 — Verificar la sintaxis nuevamente

```
named-checkconf
```

Si no muestra ningún mensaje, la sintaxis es correcta.

## 2.5 — Analizar el archivo de zona

```
named-checkzone laboratorio.local /etc/bind/zones/laboratorio.local.db
```

Si reporta un error, leé el mensaje con atención. Los errores en archivos de zona casi siempre son por:
- Falta de punto final en nombres de dominio completos (FQDN)
- Registros mal formateados

## 2.6 — Ver el archivo de zona

```
cat /etc/bind/zones/laboratorio.local.db
```

Buscá el registro `NS`. Un nombre de dominio completo (FQDN) dentro de un archivo de zona **siempre** debe terminar con punto. Por ejemplo: `ns1.laboratorio.local.` con punto al final.

## 2.7 — Reparar el archivo de zona

```
nano /etc/bind/zones/laboratorio.local.db
```

Corregí el registro NS para que termine con punto.

## 2.8 — Verificar nuevamente

```
named-checkzone laboratorio.local /etc/bind/zones/laboratorio.local.db
```

Debe responder `OK`.

## 2.9 — Iniciar bind9

```
systemctl start named
systemctl status named
```

## 2.10 — Probar la resolución

```
dig @127.0.0.1 server1.laboratorio.local +short
dig @127.0.0.1 server2.laboratorio.local +short
```

Ambas consultas deben devolver la IP correspondiente.

> **Captura sugerida:** `named-checkzone` respondiendo OK y `dig` mostrando la resolución correcta.

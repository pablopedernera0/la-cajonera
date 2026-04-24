# Paso 4 — DNS local con bind9

Un servidor DNS resuelve nombres de dominio a direcciones IP. En este paso vamos a configurar **bind9** para que resuelva nombres dentro del dominio `laboratorio.local`.

## 4.1 — Estructura de archivos de bind9

```
ls /etc/bind/
```

Los archivos clave son:
- `named.conf` — archivo principal, incluye a los demás
- `named.conf.local` — donde definimos nuestras zonas propias
- `named.conf.options` — opciones globales del servidor

## 4.2 — Configurar las opciones globales

```
cat > /etc/bind/named.conf.options << 'EOF'
options {
    directory "/var/cache/bind";

    // Reenviar consultas no resueltas a Google DNS
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    // Permitir consultas desde cualquier IP
    allow-query { any; };

    dnssec-validation no;
    listen-on { any; };
};
EOF
```

## 4.3 — Declarar la zona laboratorio.local

```
cat > /etc/bind/named.conf.local << 'EOF'
zone "laboratorio.local" {
    type master;
    file "/etc/bind/zones/laboratorio.local.db";
};
EOF
```

## 4.4 — Crear el directorio de zonas

```
mkdir -p /etc/bind/zones
```

## 4.5 — Crear el archivo de zona

Este archivo contiene los registros DNS. Cada registro tipo A asocia un nombre con una dirección IP:

```
cat > /etc/bind/zones/laboratorio.local.db << 'EOF'
$TTL    604800
@       IN      SOA     ns1.laboratorio.local. admin.laboratorio.local. (
                        2024010101  ; Serial
                        604800      ; Refresh
                        86400       ; Retry
                        2419200     ; Expire
                        604800 )    ; Negative Cache TTL

; Servidores de nombres
@       IN      NS      ns1.laboratorio.local.

; Registro A del servidor DNS
ns1     IN      A       10.0.0.1

; Registros de hosts de la red
server1 IN      A       10.0.0.10
server2 IN      A       10.0.0.11
router  IN      A       10.0.0.1
EOF
```

**¿Qué es cada campo?**

| Campo | Descripción |
|-------|-------------|
| `SOA` | Start of Authority — define quién es la autoridad de esta zona |
| `NS` | Name Server — qué servidor responde por esta zona |
| `A` | Address — asocia un nombre con una IPv4 |
| `Serial` | Número de versión del archivo. Incrementar cada vez que se modifica. |

## 4.6 — Verificar la sintaxis de los archivos

Antes de iniciar el servicio, verificar que no haya errores:

```
named-checkconf
named-checkzone laboratorio.local /etc/bind/zones/laboratorio.local.db
```

Si todo está bien, el segundo comando responde `OK`.

## 4.7 — Iniciar bind9

```
systemctl start bind9
systemctl enable bind9
```

## 4.8 — Verificar el estado

```
systemctl status bind9
```

## 4.9 — Probar la resolución de nombres

Usar `dig` para consultar el servidor DNS local:

```
dig @127.0.0.1 server1.laboratorio.local
dig @127.0.0.1 server2.laboratorio.local
dig @127.0.0.1 router.laboratorio.local
```

Y con `nslookup`:

```
nslookup server1.laboratorio.local 127.0.0.1
```

En la respuesta de `dig`, buscá la sección `ANSWER SECTION` — ahí aparece la IP resuelta para cada nombre.

> **Captura sugerida:** El archivo de zona, `named-checkzone` respondiendo OK, y la salida de `dig` mostrando la resolución de al menos un registro.

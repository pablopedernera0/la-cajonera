# Paso 2 — IP estática con Netplan

En Ubuntu 22.04 la configuración de red se gestiona con **Netplan**, que usa archivos YAML para definir cómo deben configurarse las interfaces.

## 2.1 — Ver la configuración actual

Los archivos de Netplan están en `/etc/netplan/`:

```
ls /etc/netplan/
cat /etc/netplan/*.yaml
```

Observá cómo está configurada la interfaz `enp1s0` actualmente.

## 2.2 — Crear la configuración para dummy0

Vamos a crear un archivo de configuración específico para la interfaz `dummy0` y asignarle la IP estática `10.0.0.1/24`.

```
cat > /etc/netplan/99-dummy0.yaml << 'EOF'
network:
  version: 2
  ethernets:
    dummy0:
      addresses:
        - 10.0.0.1/24
EOF
```

> **Importante:** En YAML la indentación es parte de la sintaxis. Usá siempre espacios, nunca tabs.

## 2.3 — Verificar el archivo antes de aplicar

```
cat /etc/netplan/99-dummy0.yaml
```

El archivo debe verse exactamente así:

```yaml
network:
  version: 2
  ethernets:
    dummy0:
      addresses:
        - 10.0.0.1/24
```

## 2.4 — Aplicar la configuración

```
netplan apply
```

Si hay errores de sintaxis en el YAML, Netplan los va a mostrar aquí. En ese caso revisá la indentación del archivo.

## 2.5 — Verificar la asignación

```
ip addr show dummy0
```

Deberías ver la IP `10.0.0.1/24` asignada a la interfaz.

## 2.6 — Verificar conectividad

Hacé ping a la propia interfaz para confirmar que la IP está activa:

```
ping -c 4 10.0.0.1
```

Y verificá que la conectividad original sigue funcionando:

```
ping -c 4 8.8.8.8
```

> **Captura sugerida:** `ip addr show dummy0` mostrando la IP asignada y la salida del ping.

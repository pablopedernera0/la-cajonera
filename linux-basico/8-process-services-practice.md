### Actividad Práctica: Gestionar procesos, iniciar y detener servicios.

#### Comprobar un servicio con el comando `service`

- Vamos a comprobar el estado del servidor nginx instalado anteriormente

   `service nginx status`{{exec}}
  Deberíamos ver un mensaje con información sobre el estado del servicio,
  el más importante a los fines de esta práctica es el que indica si el 
  servicio "Active: active (running)"


- Ahora vamos a parar el servidor nginx

   `service nginx stop`{{exec}}

- Y volvemos a comprobar su estado

   `service nginx status`{{exec}}   

- Esta vez el mensaje debe indicarnos que el estado del servicio es "Active: inactive (dead)"

- Volvemos a iniciar el servicio

   `service nginx start`{{exec}}

- Y finalmente volvemos a comprobar que el servicio está funcionando correctamente

   `service nginx status`{{exec}}  

#### Comprobar un servicio con el comando `systemctl`

Tal como vimos anteriormente, estas tareas también las podemos realizar con el comando `systemctl`

- Comprobar el estado del servidor nginx

   `systemctl status nginx`{{exec}}

- Parar el servidor nginx

   `systemctl stop nginx`{{exec}}

- Y volvemos a comprobar su estado

   `systemctl status nginx`{{exec}}   

- Esta vez el mensaje debe indicarnos que el estado del servicio es "Active: inactive (dead)"

- Volvemos a iniciar el servicio

   `systemctl start nginx`{{exec}}

- Y finalmente volvemos a comprobar que el servicio está funcionando correctamente

   `systemctl status nginx`{{exec}} 
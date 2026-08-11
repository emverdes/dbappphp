# PHP Birthday App

Aplicación web sencilla desarrollada en PHP que consulta y muestra una lista de cumpleaños almacenada en una base de datos MariaDB.

El proyecto está pensado como aplicación de ejemplo para prácticas de administración de servidores Linux y automatización con Ansible.

## Arquitectura

La aplicación utiliza dos componentes:

```text
Cliente
   |
   | HTTP
   v
Apache + PHP
   |
   | TCP/3306
   v
MariaDB
```

Los componentes pueden instalarse indistintamente en **CentOS Stream** o **Ubuntu Server**.

Por ejemplo:

```text
Opción A
CentOS Stream  -> Apache + PHP
Ubuntu Server  -> MariaDB
```

o:

```text
Opción B
Ubuntu Server  -> Apache + PHP
CentOS Stream  -> MariaDB
```

## Contenido del repositorio

```text
.
├── cumple.php       Aplicación web PHP
├── database.sql     Creación de la base de datos y datos iniciales
└── README.md        Documentación del proyecto
```

## Servidor de aplicación

El servidor de aplicación requiere:

* Apache HTTP Server
* PHP
* Extensión PHP para MySQL/MariaDB

### CentOS Stream

```bash
sudo dnf install -y httpd php php-mysqlnd
sudo systemctl enable --now httpd
```

Permitir HTTP en `firewalld`:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

El directorio web predeterminado es:

```text
/var/www/html
```

### Ubuntu Server

```bash
sudo apt update
sudo apt install -y apache2 php libapache2-mod-php php-mysql
sudo systemctl enable --now apache2
```

Si UFW está habilitado:

```bash
sudo ufw allow "Apache"
```

El directorio web predeterminado es:

```text
/var/www/html
```

## Servidor de base de datos

El servidor de base de datos requiere MariaDB Server.

### CentOS Stream

```bash
sudo dnf install -y mariadb-server
sudo systemctl enable --now mariadb
```

Si se utiliza `firewalld`, permitir el acceso a MariaDB desde el servidor de aplicación:

```bash
sudo firewall-cmd --permanent \
  --add-rich-rule='rule family="ipv4" source address="IP_SERVIDOR_APLICACION" port port="3306" protocol="tcp" accept'

sudo firewall-cmd --reload
```

### Ubuntu Server

```bash
sudo apt update
sudo apt install -y mariadb-server
sudo systemctl enable --now mariadb
```

Si se utiliza UFW, permitir MariaDB únicamente desde el servidor de aplicación:

```bash
sudo ufw allow from IP_SERVIDOR_APLICACION to any port 3306 proto tcp
```

## Configuración de MariaDB

MariaDB debe escuchar en una dirección accesible desde el servidor de aplicación.

Dependiendo de la distribución y versión, revisar la directiva:

```text
bind-address
```

y configurarla para escuchar en la interfaz correspondiente.

Después de modificar la configuración:

```bash
sudo systemctl restart mariadb
```

## Base de datos

La aplicación necesita:

* Una base de datos llamada `cumpleanos`.
* Una tabla llamada `personas`.
* Un usuario específico para la aplicación.

Ejemplo:

```sql
CREATE DATABASE cumpleanos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER 'cumpleapp'@'IP_SERVIDOR_APLICACION'
  IDENTIFIED BY 'CAMBIAR_CONTRASENA';

GRANT SELECT ON cumpleanos.*
  TO 'cumpleapp'@'IP_SERVIDOR_APLICACION';

FLUSH PRIVILEGES;
```

No se recomienda permitir acceso mediante:

```text
'cumpleapp'@'%'
```

cuando se conoce la dirección del servidor de aplicación.

## Configuración de la aplicación

La aplicación necesita los siguientes parámetros:

* Dirección del servidor MariaDB.
* Puerto de MariaDB.
* Nombre de la base de datos.
* Usuario.
* Contraseña.

Estos valores deben ajustarse antes de desplegar la aplicación.

En una instalación automatizada pueden generarse mediante un template de Ansible.

## Despliegue de la aplicación

Copiar la aplicación al directorio publicado por Apache:

```bash
sudo cp cumple.php /var/www/html/index.php
sudo chmod 0644 /var/www/html/index.php
```

El propietario y grupo deberán ajustarse según la distribución y la configuración de Apache.

## Prueba de conectividad con MariaDB

Desde el servidor de aplicación puede verificarse primero el acceso al puerto:

```bash
nc -zv IP_SERVIDOR_DATABASE 3306
```

Si está instalado el cliente MariaDB:

```bash
mariadb \
  -h IP_SERVIDOR_DATABASE \
  -u cumpleapp \
  -p \
  cumpleanos
```

## Prueba de la aplicación

Desde un cliente:

```bash
curl http://IP_SERVIDOR_APLICACION/
```

La página debe mostrar la lista de cumpleaños almacenada en MariaDB.

## Uso educativo

El proyecto puede utilizarse para practicar:

* Administración de CentOS Stream y Ubuntu Server.
* Diferencias entre `dnf` y `apt`.
* Administración de servicios con systemd.
* Apache y PHP.
* MariaDB.
* `firewalld` y UFW.
* Comunicación entre servidores.
* Configuración de red.
* Git.
* Automatización mediante Ansible.
* Variables, templates y handlers.
* Idempotencia.

Una posible actividad consiste en instalar inicialmente la aplicación en CentOS Stream y MariaDB en Ubuntu Server y posteriormente invertir los roles de ambos servidores.

## Seguridad

Este proyecto está destinado a entornos educativos.

Antes de utilizarlo fuera de un laboratorio se deberá:

* Evitar contraseñas incorporadas directamente en el código.
* Proteger las credenciales.
* Restringir el acceso remoto a MariaDB.
* Mantener activos los firewalls.
* Abrir solamente los puertos necesarios.
* Configurar HTTPS.
* Evitar mostrar detalles internos de errores al usuario.



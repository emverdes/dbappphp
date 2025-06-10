# dbappphp
Simple php database app

Install necesary packages
``` 
# sudo dnf install -y httpd php php-fpm php-mysqlnd mariadb mariadb-server
```
Start mariadb server and run mysql_secure_installation to harden the database install
Follow the script instruction

```
# systemctl enable mariadb --now
# mysql_secure_installation
```

Create user for app
```
CREATE USER 'intranet'@'%' IDENTIFIED BY 'secureKey';
GRANT SELECT ON cumples.* TO 'intranet'@'%';
FLUSH PRIVILEGES;
EXIT;
```


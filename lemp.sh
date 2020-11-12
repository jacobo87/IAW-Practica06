#!/bin/bash

# Configuracion del scritp
# Definimos la ruta donde vamos a guardar el archivo .htpasswd
HTTPASSWD_DIR=/home/ubuntu
HTTPASSWD_USER=usuario
HTTPASSWD_PASSWD=usuario
# IP Servidor MySQL
IPPRIVADA=172.31.27.177

# ------------------------------------------------------------------------------ Instalación de la pila LEMP ------------------------------------------------------------------------------ 

# Habilitamos el modo de shell para mostrar los comandos que se ejecutan
set -x
# Actualizamos la lista de paquetes
apt-get update
# Instalamos el servidor web Apache -y le decimos que si
apt-get install nginx -y
# Instalamos los módulos necesarios de PHP
apt-get install php-fpm php-mysql -y
# Configuración de php-fpm
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini
# Reiniciamos el servicio
systemctl restart php7.4-fpm
# Copiamos el archivo de configuración
cp default /etc/nginx/sites-available/
# Reiniciamos el servicio de nginx
systemctl restart nginx

# ------------------------------------------------------------------------------ Instalación aplicación web ------------------------------------------------------------------------------ 
# Clonamos el repositorio de la aplicación
cd /var/www/html 
rm -rf iaw-practica-lamp 
git clone https://github.com/josejuansanchez/iaw-practica-lamp

# Movemos el contenido del repositorio al home de html
mv /var/www/html/iaw-practica-lamp/src/*  /var/www/html/

# Configuramos el archivo php de la aplicacion
# sed -i "s/localhost/$IPPRIVADA/" /var/www/html/config.php

# Eliminamos el archivo Index.html de nginx
rm -rf /var/www/html/index.html
rm -rf /var/www/html/iaw-practica-lamp/

# Instalamos unzip
apt install unzip -y
# Instalación de Phpmyadmin
cd /home/ubuntu
rm -rf phpMyAdmin-5.0.4-all-lenguages.zip
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-lenguages.zip
# Descomprimimos 
nzip phpMyAdmin-5.0.4-all-lenguages.zip
# Borramos el archivo .zip
rm -rf phpMyAdmin-5.0.4-all-lenguages.zip
# Movemos la carpeta al directorio
mv phpMyAdmin-5.0.4-all-lenguages /var/www/html/phpmyadmin
# Configuaramos el archivo config.sample.inc.php
cd /var/www/html/phpmyadmin
mv config.sample.inc.php config.inc.php
sed -i "s/localhost/$IPPRIVADA/" /var/www/html/config.inc.php

# Cambiamos permisos 
chown www-data:www-data * -R


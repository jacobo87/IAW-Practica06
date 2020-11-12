# IAW - Práctica 5 
>IES Celia Viñas (Almería) - Curso 2020/2021  
>Módulo: IAW - Implantación de Aplicaciones Web  
>Ciclo: CFGS Administración de Sistemas Informáticos en Red  

1. LEMP Stack 
- Instalación del servidor web Nginx 
- Instalación de php-fpm y php-mysql 
- Configuración de php-fpm 
- Configurar Nginx para usar php-fpm 
2. Referencias 

## 1 LEMP Stack

En esta práctica vamos a instalar la pila LEMP que es una variación de la pila LAMP. La única diferencia es que usa el servidor Nginx en lugar de Apache.

Nginx está considerado como un servidor web ligero de alto rendimiento que además suele ser utilizado como proxy inverso y balanceador de carga.
### Instalación del servidor web Nginx

``sudo apt-get update``
``sudo apt-get install nginx``

### Instalación de php-fpm y php-mysql

El paquete php-fpm (PHP FastCGI Process Manager) es una implementación alternativa al PHP FastCGI con algunas características adicionales útiles para sitios web com mucho tráfico.

El paquete php-mysql permite a PHP interaccionar con el sistema gestor de bases de datos MySQL.

``sudo apt-get install php-fpm php-mysql``

### Configuración de php-fpm

Es recomendable realizar un cambio en la directiva de configuración cgi.fix_pathinfo por cuestiones de seguridad. Editamos el siguiente archivo de configuración:

```bash
sudo nano /etc/php/7.2/fpm/php.ini
```

> NOTA: En el momento de redactar esta guía la versión de PHP es la 7.2. Tenga en cuenta que esta versión puede cambiar en un futuro.

Buscamos la directiva de configuración cgi.fix_pathinfo que por defecto aparece comentada con un punto y coma y con un valor igual a 1.

```bash
;cgi.fix_pathinfo=1
```

Eliminamos el punto y coma y la configuramos con un valor igual a 0.

```bash
cgi.fix_pathinfo=0
```

Una vez modificado el archivo de configuración y guardados los cambios reiniciamos el servicio php7.2-fpm.

```bash
sudo systemctl restart php7.2-fpm
```

### Configurar Nginx para usar php-fpm

Editamos el archivo de configuración```bash
/etc/nginx/sites-available/default``` :

```bash
sudo nano /etc/nginx/sites-available/default
```

Realizamos los siguientes cambios:

- En la sección ```index``` añadimos el valor ``index.php`` en primer lugar para que darle prioridad respecto a los archivos ``index.html``.
- Añadimos el bloque ``location ~ \.php$`` indicando dónde se encuentra el archivo de configuración ``fastcgi-php.conf`` y el archivo ``php7.2-fpm.sock``.

Opcionalmente podemos añadir el bloque ``location ~ /\.ht`` para no permitir que un usuario pueda descargar los archivos ``.htaccess``. Estos archivos no son procesados por Nginx, son específicos de Apache.

Un posible archivo de configuración para el servidor podría ser el siguiente:

```
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.php index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                # With php7.2-fpm:
                fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        location ~ /\.ht {
                deny all;
        }
}
```

Podemos comprobar que la sintaxis del archivo de configuración es correcta con el comando:

``sudo ngingx -t``

Una vez realizados los cambios reiniciamos el servicio nginx:

``sudo systemctl restart nginx``

## 2 Referencias

- https://josejuansanchez.org/iaw/practica-06-teoria/index.html
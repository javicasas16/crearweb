#!/bin/bash
#SCRIPT PARA CREAR UNA NUEVA
#Creamos dentro de /var/www una carpeta con el nombre de la
#web que vamos a crear
#NOTA $1 será el nombre de la web, si la web es youtube.com, $1 es youtube
#NOTA $2 será el sufijo de la web, si la web es youtube.com, $2 es .com
#NOTA Éstos parámetros se introducen desde la aplicación web

if [ -d /var/www/$1 ] ; then
        echo "Error, la web $1 ya existe"
else
        mkdir /var/www/$1
        echo "Se ha creado el directorio /var/www/$1"
        #Se crea el index.html con un mensaje de bienvenida
        touch /var/www/$1/index.html
        echo "<html> &Eacute;sta es la web $1.$2</html>" > /var/www/$1/index.html
        echo "Se ha creado el archivo index.html de la web $1.$2"
fi

#A partir de ahora pasamos a configurar el servidor web apache2
if [ $3 = "s" ] ; then
        # dr = directorio raiz
        dr="            Options Indexes FollowSymLinks MultiViews"
else
        dr="            Options -Indexes FollowSymLinks MultiViews"
fi


#Creamos el archivo de configuracion de sites-available
touch /etc/apache2/sites-available/$1

echo "<VirtualHost *:80>" > /etc/apache2/sites-available/$1
echo "  ServerAdmin webmaster@localhost" >>/etc/apache2/sites-available/$1
echo "  ServerName www.$1.$2" >>/etc/apache2/sites-available/$1
echo "  ServerAlias $1.$2" >>/etc/apache2/sites-available/$1
echo " " >> /etc/apache2/sites-available/$1
echo "  DocumentRoot /var/www/$1" >> /etc/apache2/sites-available/$1
echo "  <Directory />" >> /etc/apache2/sites-available/$1
echo "          Options FollowSymLinks" >> /etc/apache2/sites-available/$1
echo "          AllowOverride None" >> /etc/apache2/sites-available/$1
echo "  </Directory>" >> /etc/apache2/sites-available/$1
echo "  <Directory /var/www/$1>" >> /etc/apache2/sites-available/$1
echo $dr >> /etc/apache2/sites-available/$1
echo "          AllowOverride None" >> /etc/apache2/sites-available/$1
echo "          Order allow,deny" >> /etc/apache2/sites-available/$1
echo "          allow from all" >> /etc/apache2/sites-available/$1
echo "  </Directory>" >> /etc/apache2/sites-available/$1
echo " " >> /etc/apache2/sites-available/$1
echo "        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/" >> /etc/apache2/sites-available/$1
echo '  <Directory "/usr/lib/cgi-bin">' >> /etc/apache2/sites-available/$1
echo "          AllowOverride None" >> /etc/apache2/sites-available/$1
echo "          Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch" >> /etc/apache2/sites-available/$1
echo "          Order allow,deny" >> /etc/apache2/sites-available/$1
echo "          Allow from all" >> /etc/apache2/sites-available/$1
echo "  </Directory>" >> /etc/apache2/sites-available/$1
echo " " >> /etc/apache2/sites-available/$1
echo "  ErrorLog ${APACHE_LOG_DIR}/error.log" >> /etc/apache2/sites-available/$1
echo " " >> /etc/apache2/sites-available/$1
echo "  # Possible values include: debug, info, notice, warn, error, crit," >> /etc/apache2/sites-available/$1
echo "  # alert, emerg." >> /etc/apache2/sites-available/$1
echo "  LogLevel warn" >> /etc/apache2/sites-available/$1
echo " " >> /etc/apache2/sites-available/$1
echo "  CustomLog ${APACHE_LOG_DIR}/access.log combined" >> /etc/apache2/sites-available/$1
echo " " >> /etc/apache2/sites-available/$1
echo "  Alias /doc/ "/usr/share/doc/"" >> /etc/apache2/sites-available/$1
echo "  <Directory "/usr/share/doc/">" >> /etc/apache2/sites-available/$1
echo "          Options Indexes MultiViews FollowSymLinks" >> /etc/apache2/sites-available/$1
echo "          AllowOverride None" >> /etc/apache2/sites-available/$1
echo "          Order deny,allow" >> /etc/apache2/sites-available/$1
echo "          Deny from all" >> /etc/apache2/sites-available/$1
echo "          Allow from 127.0.0.0/255.0.0.0 ::1/128" >> /etc/apache2/sites-available/$1
echo "  </Directory>" >> /etc/apache2/sites-available/$1
echo " " >> /etc/apache2/sites-available/$1
echo "</VirtualHost>" >> /etc/apache2/sites-available/$1

#Se crea un enlace duro hacia sites-enabled
ln /etc/apache2/sites-available/$1 /etc/apache2/sites-enabled/$1
echo "Se ha creado un enlace duro de sites available a sites enabled"

#Se reinicia el servidor web
service apache2 restart
echo "Se ha reiniciado el servidor web"
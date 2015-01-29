 #!/bin/bash
 #SCRIPT PARA BORRAR UNA WEB EXISTENTE
 if [ -d /var/www/$1 ]; then
 	rm -R /var/www/$1
 	echo "se ha eliminado el directorio raiz de la web $1.$2"
 	rm /etc/apache2/sites-enabled/$1
 	rm /etc/apache2/sites-available/$1
 	echo "Se han eliminado los archivos de configuración de la web en el servidor"
 else
 	echo "Error, la Web $1.$2 no existe"
 fi
 

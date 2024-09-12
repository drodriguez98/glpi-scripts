#!/bin/bash

# Aplica las configuraciones recomendadas para GLPI en el archivo php.ini y elimina el archivo de la instalación de GLPI.

# Nota: Añadir ServerName en /etc/apache2/apache2.conf (ServerName localhost por ejemplo) para que Apache no dé error al reiniciar el servicio

# Ruta al archivo php.ini
PHP_INI_PATH="/etc/php/8.3/apache2/php.ini"
GLPI_INSTALL_FILE_PATH="/var/www/html/glpi/install/install.php"

# Cambios que se deben realizar
declare -A CONFIG_CHANGES=(
    ["memory_limit"]="512M"
    ["file_uploads"]="On"
    ["max_execution_time"]="600"
    ["session.auto_start"]="Off"
    ["session.use_trans_sid"]="0"
)

# Backup del archivo php.ini
cp $PHP_INI_PATH $PHP_INI_PATH.bak

# Modificar los valores en php.ini
for key in "${!CONFIG_CHANGES[@]}"; do
    sed -i "s/^${key} =.*/${key} = ${CONFIG_CHANGES[$key]}/I" "$PHP_INI_PATH"
done

echo "Configuración de $PHP_INI_PATH actualizada."

# Verificar si el archivo de instalación de GLPI existe y eliminarlo si es necesario
if [ -f "$GLPI_INSTALL_FILE_PATH" ]; then
    rm "$GLPI_INSTALL_FILE_PATH"
    echo "El archivo de instalación $GLPI_INSTALL_FILE_PATH ha sido eliminado."
else
    echo "El archivo de instalación $GLPI_INSTALL_FILE_PATH ya se había eliminado previamente."
fi

# Reiniciar Apache
systemctl restart apache2
echo "Apache reiniciado."

#!/bin/bash

# Añadir ServerName en /etc/apache2/apache2.conf (ServerName localhost por ejemplo) para que Apache no dé error al reiniciar el servicio


# Ruta al archivo php.ini
PHP_INI_PATH="/etc/php/8.3/apache2/php.ini"

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

echo "Configuracion de $PHP_INI_PATH actualizada."

# Reiniciar Apache
systemctl restart apache2
echo "Apache reiniciado."
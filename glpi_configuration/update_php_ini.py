import re

# Ruta al archivo php.ini
php_ini_path = '/etc/php/8.3/apache2/php.ini'

# Valores a cambiar
config_changes = {
    'memory_limit': '512M',
    'file_uploads': 'On',
    'max_execution_time': '600',
    'session.auto_start': 'Off',
    'session.use_trans_sid': '0'
}

def update_php_ini(file_path, changes):
    # Leer el archivo php.ini
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Modificar los valores
    with open(file_path, 'w') as file:
        for line in lines:
            key_found = False
            for key, value in changes.items():
                if re.match(f'^{key}\s*=', line.strip(), re.IGNORECASE):
                    file.write(f'{key} = {value}\n')
                    key_found = True
                    break
            if not key_found:
                file.write(line)

# Ejecutar la actualización
update_php_ini(php_ini_path, config_changes)
print(f'Configuración de {php_ini_path} actualizada.')
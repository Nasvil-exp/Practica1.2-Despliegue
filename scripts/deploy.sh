#!/bin/bash

set -e

# Directorio de la aplicación
APP_DIR="/var/www/html"
REPO_DIR="/tmp/iaw-practica-lamp"

echo "Iniciando el despliegue de la aplicación LAMP..."

# Descargar la aplicación si todavía no existe
if [ ! -d "$REPO_DIR/.git" ]; then
    git clone https://github.com/josejuansanchez/iaw-practica-lamp.git "$REPO_DIR"
fi

# Comprobar que existe el código de la aplicación
if [ ! -d "$REPO_DIR/src" ]; then
    echo "Error: no se encuentra el directorio src."
    exit 1
fi

# Copiar los archivos sin sobrescribir config.php
sudo find "$REPO_DIR/src/" -mindepth 1 -maxdepth 1 ! -name "config.php" -exec cp -r -t "$APP_DIR/" {} +

# Configurar permisos
sudo chown -R www-data:www-data "$APP_DIR"

# Comprobar Apache
sudo apache2ctl configtest

# Reiniciar Apache
sudo systemctl restart apache2

echo "Despliegue finalizado correctamente."

#!/bin/sh

# ----------------------------------------------------------------
echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo apt-get update -y
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nInstalling Apache2 Web server\n"
sudo apt-get install apache2 apache2-utils libexpat1 ssl-cert -y
sudo ufw allow in \"Apache\""
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nPermissions for /var/www\n"
sudo chown -R www-data:www-data /var/www
sudo chown www-data:www-data /var/www/html/ -R
echo -e "\n\n Permissions have been set\n"
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nInstalling PHP & Requirements\n"
sudo apt install -y libapache2-mod-php
sudo apt install -y php-{mysql,zip,json,common,bcmath,common,cli,dev,mcrypt,curl,opcache,readline}
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nEnabling Modules\n"
sudo a2enmod rewrite
sudo phpenmod mcrypt
sudo a2enmod php8.1
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nRestarting Apache\n"
sudo echo \"<?php phpinfo(); ?>\"  > /home/ubuntu/index.php
sudo mv /home/ubuntu/index.php /var/www/html/
sudo systemctl restart apache2
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nInstalling MariaDB\n"
sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo mysql_secure_installation --use-default
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nInstalling phpmyadmin\n"

# Stop the script if anything goes wrong.
set -e

echo "Change directory to home directory..."
cd ~ || {
  echo 'Failed to change directory to home! Task aborted!!'
  return
}
printf "Task done.\n\n"
# ----------------------------------------------------------------
echo "Downloading the latest phpMyAdmin archive..."
DATA="$(wget https://www.phpmyadmin.net/home_page/version.txt -q -O-)"
URL="$(echo "$DATA" | tail +3 | cut -d# -f2)"
OUTPUT_FILE_NAME="phpMyAdmin.zip"
wget -O "$OUTPUT_FILE_NAME" "$URL"
printf "Task done.\n\n"
# ----------------------------------------------------------------

echo "Extracting the downloaded archive..."
DOWNLOADED_FILE_NAME="$(basename "$URL")"
if [ "${DOWNLOADED_FILE_NAME##*.}" = "zip" ]; then
  EXTRACT_FOLDER_NAME="${DOWNLOADED_FILE_NAME%.zip}"
  unzip "$OUTPUT_FILE_NAME"
  printf "Task done.\n\n"
else
  echo "The downloaded file is not a zip! Task aborted!"
  return
fi
# ----------------------------------------------------------------

echo "Removing downloaded archive..."
rm $OUTPUT_FILE_NAME
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Removing previous /usr/share/phpmyadmin folder if exist..."
sudo rm -rf /usr/share/phpmyadmin/
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Moving the extracted folder..."
sudo mv "$EXTRACT_FOLDER_NAME/" /usr/share/phpmyadmin
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Creating temp directory and changing ownership..."
TEMP_DIRECTORY="/var/lib/phpmyadmin/tmp"
if [ ! -d $TEMP_DIRECTORY ]; then
  sudo mkdir -p $TEMP_DIRECTORY
fi
sudo chown -R www-data:www-data /var/lib/phpmyadmin
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Creating phpMyAdmin configuration directory..."
ETC_PHPMYADMIN_DIR="/etc/phpmyadmin/"
if [ ! -d $ETC_PHPMYADMIN_DIR ]; then
  sudo mkdir -p $ETC_PHPMYADMIN_DIR
else
  echo "$ETC_PHPMYADMIN_DIR directory already exist!"
fi
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Creating phpMyAdmin configuration files..."
sudo cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Editing newly created config.inc.php file..."
echo "Generating blowfish_secret..."
OLD_BLOW_FISH_CONF="\['blowfish_secret'\] = '';"
NEW_BLOW_FISH_CONF="\['blowfish_secret'\] = '$(openssl rand -base64 32)';"
sudo sed -i "s|$OLD_BLOW_FISH_CONF|$NEW_BLOW_FISH_CONF|g" /usr/share/phpmyadmin/config.inc.php
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Adding temp directory configuration to config.inc.php file..."
CFG_TEMP_DIR="\$cfg['TempDir'] = '$TEMP_DIRECTORY';"
if ! grep -Fxq "$CFG_TEMP_DIR" /usr/share/phpmyadmin/config.inc.php; then
  echo "\$cfg['TempDir'] = '$TEMP_DIRECTORY';" | sudo tee -a /usr/share/phpmyadmin/config.inc.php >/dev/null
else
  echo "'$CFG_TEMP_DIR' already found in the config.inc.php file."
fi
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Configuring Apache web server..."
PHP_MY_ADMIN_CONF_FILE="/etc/apache2/conf-enabled/phpmyadmin.conf"
sudo touch $PHP_MY_ADMIN_CONF_FILE
PHP_MY_ADMIN_CONF_CONTENT=$(
  cat <<-END
Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php

    <IfModule mod_php5.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>
    <IfModule mod_php.c>
        <IfModule mod_mime.c>
            AddType application/x-httpd-php .php
        </IfModule>
        <FilesMatch ".+\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>

        php_value include_path .
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/:/usr/share/doc/phpmyadmin/:/usr/share/php/phpseclib/
        php_admin_value mbstring.func_overload 0
    </IfModule>

</Directory>

# Authorize for setup
<Directory /usr/share/phpmyadmin/setup>
    <IfModule mod_authz_core.c>
        <IfModule mod_authn_file.c>
            AuthType Basic
            AuthName "phpMyAdmin Setup"
            AuthUserFile /etc/phpmyadmin/htpasswd.setup
        </IfModule>
        Require valid-user
    </IfModule>
</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/setup/lib>
    Require all denied
</Directory>
END
)
echo "$PHP_MY_ADMIN_CONF_CONTENT" | sudo tee -a $PHP_MY_ADMIN_CONF_FILE >/dev/null
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Restarting Apache server..."
sudo systemctl restart apache2
printf "Task done.\n\n"

# ----------------------------------------------------------------

echo "Everything is successfully done. Enjoy..."
echo -e "\n\nLAMP Installation Completed"

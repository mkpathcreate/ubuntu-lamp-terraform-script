#!/bin/sh

# ----------------------------------------------------------------
echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo apt-get update -y
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nUninstalling Apache2 Web server\n"
sudo apt-get remove --purge apache2 apache2-utils libexpat1 ssl-cert -y
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nUninstalling PHP & Requirements\n"
sudo apt remove --purge -y libapache2-mod-php
sudo apt remove --purge -y php-{mysql,zip,json,common,bcmath,common,cli,dev,mcrypt,curl,opcache,readline}
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nUninstalling MariaDB\n"
sudo apt remove --purge -y mariadb-server mariadb-client
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nUninstalling phpmyadmin\n"

sudo apt remove --purge phpmyadmin
sudo reboot
echo -e "\n\nLAMP Installation Completed"

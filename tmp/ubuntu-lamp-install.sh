#!/bin/bash

# ----------------------------------------------------------------
echo -e "\n\nUpdating Apt Packages and upgrading latest patches\n"
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
sudo apt update -y
sudo apt-get -y install debconf-utils
sudo apt install zip -y
sudo apt install unzip -y
sudo snap switch --channel=candidate amazon-ssm-agent
sudo snap switch --channel=candidate amazon-ssm-agent
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nInstalling Apache2 Web server\n"
sudo apt install apache2 -y
sudo ufw allow in \"Apache\"
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
sudo apt install -y php
sudo apt install -y php-{mysql,zip,json,common,bcmath,common,cli,dev,curl,opcache,readline}
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nEnabling Modules\n"
sudo a2enmod rewrite
sudo phpenmod mcrypt
sudo phpenmod mbstring
sudo a2enmod php8.1
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nRestarting Apache\n"
sudo systemctl restart apache2
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo -e "\n\nInstalling MariaDB\n"
sudo export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections<<<"mariadb-server mysql-server/root_password password Rhytha268!"
sudo debconf-set-selections<<<"mariadb-server mysql-server/root_password_again password Rhytha268!" 
sudo DEBIAN_FRONTEND=noninteractive sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable mariadb
sudo systemctl start mariadb
# ----------------------------------------------------------------

#---------phpmyadmin----------------------------------------------
# Preparing PhpMyAdmin installation
sudo debconf-set-selections<<<'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections<<<'phpmyadmin phpmyadmin/app-password-confirm password phpmyadmin_PASSWORD'
sudo debconf-set-selections<<<'phpmyadmin phpmyadmin/mysql/admin-pass password phpmyadmin_PASSWORD'
sudo debconf-set-selections<<<'phpmyadmin phpmyadmin/mysql/app-pass password phpmyadmin_PASSWORD'
sudo debconf-set-selections<<<'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'

# PhpMyAdmin installation & configuration
sudo DEBIAN_FRONTEND=noninteractive apt install -q -y phpmyadmin
#Changing phpmyadmin access url
#randomized phpmyadmin url for security
#phpmyadmin_url=$(tr </dev/urandom -dc A-Za-z0-9_- | head -c32)
phpmyadmin_url="phpmyadmin"
sudo sed -i 's/Alias \/phpmyadmin \/usr\/share\/phpmyadmin/#Alias \/phpmyadmin \/usr\/share\/phpmyadmin\nAlias \/'$phpmyadmin_url' \/usr\/share\/phpmyadmin/' /etc/apache2/conf-available/phpmyadmin.conf
#echo "CREATE USER 'mariaadmin'@localhost IDENTIFIED BY 'Rhytha268!';GRANT ALL PRIVILEGES ON *.* TO 'mariaadmin'@localhost IDENTIFIED BY 'Rhytha268!';FLUSH PRIVILEGES;" | sudo mysql -u root



sudo service apache2 reload

sudo echo -en "[mysql]\nuser=root\npassword=mysql_PASSWORD\n" >~/.my.cnf
sudo chmod 0600 ~/.my.cnf
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo "Letsencrypt for SSL..."	
	sudo apt-get -y install python-certbot-apache
# ----------------------------------------------------------------

# ----------------------------------------------------------------
echo "Restarting Apache server..."
sudo systemctl restart apache2
printf "Task done.\n\n"
# ----------------------------------------------------------------
echo -e "###########  * DETIALS *  ###########\n\nSite Directory : /var/www/html/$domain\nHost file for $domain : /etc/apache2/sites-available/$domain.conf\n-------------------------------------\nPhpMyAdmin URL : $domain/$phpmyadmin_url\nMySQL Information -\n\t user : root\n\t password : Rhytha268! \n-------------------------------------\n\n\tCreate a backup for Directory : /etc/letsencrypt/" | tee -a details.txt

echo "Everything is successfully done. Enjoy..."
exit 0
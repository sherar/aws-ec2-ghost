#!/bin/bash

export PATH=$PATH:/usr/local/bin

# Creates a new user with home directory, which will have root access for the ghost installation
sudo adduser -m ghostadmin
sudo usermod -aG sudo ghostadmin

# Upgrade to latest version
apt-get update
apt-get upgrade -y

# Install NGINX
apt-get install nginx=1.18.0-6ubuntu14.1 -y
#ufw allow 'Nginx Full'

# Setup MySQL
apt-get install mysql-server=8.0.29-0ubuntu0.22.04.2  -y
mysql_secure_installation

cat <<"EOF" > /home/ubuntu/setup.sql
${sql_config}
EOF

mysql --host="localhost" --user="root" < /home/ubuntu/setup.sql

# Install NodeJS @ 12
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash
apt-get install -y nodejs

# Install Ghost CLI
npm install ghost-cli@1.19.3 -g

# Setup Ghost
sudo mkdir -p /var/www/ghost
sudo chown ghostadmin:ghostadmin /var/www/ghost
sudo chmod 775 /var/www/ghost

sudo su ghostadmin --command "cd /var/www/ghost && ghost install"
sudo su ghostadmin --command "cd /var/www/ghost && ghost setup --db 'mysql' --dbhost 'localhost' --dbuser 'ghostadmin' --dbpass '${var.db_pass}' --dbname '${var.db_name}'"
sudo su ghostadmin --command "cd /var/www/ghost && ghost start"

# Saves a snapshot of the production site under /backup directory
(crontab -l 2>/dev/null; echo "* * * * * mysqldump -h localhost -u ghostadmin -ppassword ${var.db_pass}' | gzip > /backup/mysql-$(date '+%d_%m_%Y__%H_%M_%S').zip") | crontab -


source ./files/lico_env.local

mysql -e "CREATE DATABASE lico /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -e "CREATE USER ${LICO_MYSQL_USERNAME}@localhost IDENTIFIED BY '${LICO_MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON lico.* TO '${LICO_MYSQL_USERNAME}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"





lico-password-tool --mariadb --user ${LICO_MYSQL_USERNAME} --password ${LICO_MYSQL_PASSWORD}
lico-password-tool --confluent --user ${LICO_CONFLUENT_USERNAME} --password ${LICO_CONFLUENT_PASSWORD}
lico-password-tool --influxdb --user ${LICO_INFLUXDB_USERNAME} --password ${LICO_INFLUXDB_PASSWORD}

icinga_user=$(cat /etc/icinga2/conf.d/api-users.conf | grep -oP 'ApiUser "\K[^"]+')
icinga_password=$(cat /etc/icinga2/conf.d/api-users.conf | grep -oP 'password = "\K[^"]+')
lico-password-tool --icinga --user $icinga_user --password $icinga_password

lico-password-tool --ldap --password ${LICO_LDAP_PASSWORD}


# Configure service account for other nodes
/opt/confluent/bin/nodeshell all mkdir -p /var/lib/lico/tool
cp /var/lib/lico/tool/.db /install/installer
/opt/confluent/bin/nodeshell all cp /install/installer/.db /var/lib/lico/tool

lico init

# Initialize users
# Import system images

systemctl disable httpd --now
# Start LiCO
if [ $num_logins -gt 0 ]
then
psh login systemctl enable nginx --now
echo ------------------------------------------------
echo "Remember to configure nginx on the LOGIN node"
echo ------------------------------------------------
else
cat ./files/nginx.conf > /etc/nginx/nginx.conf
systemctl enable nginx --now
fi




#lico-service-tool enable
#lico-service-tool start

lico import_user -u root -r admin

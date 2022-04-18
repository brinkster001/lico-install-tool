source ${download_folder}/lico_env.local

dnf install -y rabbitmq-server
systemctl enable rabbitmq-server --now

dnf install -y mariadb-server mariadb-devel
systemctl enable mariadb --now

# configure MariaDB limits
sed -i "/\[mysqld\]/a\max-connections=1024" /etc/my.cnf.d/mariadb-server.cnf
mkdir /usr/lib/systemd/system/mariadb.service.d
cat << eof > /usr/lib/systemd/system/mariadb.service.d/limits.conf
[Service]
LimitNOFILE=10000
eof
systemctl daemon-reload
systemctl restart mariadb


# Install InfluxDB
dnf install -y influxdb
systemctl enable influxdb --now

sleep 5

influx -execute "create database lico"
influx -database 'lico' -host 'localhost' -port '8086' -execute "create user ${LICO_INFLUXDB_USERNAME} with password '${LICO_MYSQL_PASSWORD}' with all privileges"



sed -i '/# auth-enabled = false/a\ auth-enabled = true' /etc/influxdb/config.toml
systemctl restart influxdb 

# Install OpenLDAP-server
dnf install -y slapd-ssl-config openldap-servers

sed -i "s/dc=hpc,dc=com/${lico_ldap_domain_name}/" /usr/share/openldap-servers/lico.ldif
sed -i "/dc:/s/hpc/${lico_ldap_domain_component}/" /usr/share/openldap-servers/lico.ldif
sed -i "s/dc=hpc,dc=com/${lico_ldap_domain_name}/" /etc/openldap/slapd.conf
slapadd -v -l /usr/share/openldap-servers/lico.ldif -f /etc/openldap/slapd.conf -b \
${lico_ldap_domain_name}


sed -i "/rootpw          openldap/c\rootpw    $(slappasswd -s ${LICO_LDAP_PASSWORD})" /etc/openldap/slapd.conf

chown -R ldap:ldap /var/lib/ldap
chown ldap:ldap /etc/openldap/slapd.conf


# !!!! Edit configuration file /etc/sysconfig/slapd, and ensure that the following commands are
# UNcommented. //  @LiCOs v6.1 - THEY ALREADY ARE 
# SLAPD_URLS="ldapi:/// ldap:/// ldaps:///"
# SLAPD_OPTIONS="-f /etc/openldap/slapd.conf"
systemctl enable slapd --now



# Install libuser
dnf install -y libuser python3-libuser


cat ${download_folder}/libuser.conf > /etc/libuser.conf
sed -i "/server = ldap:\/\/<LDAP_ADDRESS>/c\server = ldap:\/\/${sms_ip}" /etc/libuser.conf
sed -i "/basedn = <DOMAIN>/c\basedn = ${lico_ldap_domain_name}" /etc/libuser.conf
sed -i "/binddn = uid=admin,<DOMAIN>/c\binddn = uid=admin,${lico_ldap_domain_name}" /etc/libuser.conf


# Install OpenLDAP-client


echo "TLS_REQCERT never" >> /etc/openldap/ldap.conf
cp /etc/openldap/ldap.conf /install/installer
/opt/confluent/bin/nodeshell all cp /install/installer/ldap.conf /etc/openldap/ldap.conf

# Install nss-pam-ldapd
dnf install -y nss-pam-ldapd

/opt/confluent/bin/nodeshell all dnf install -y nss-pam-ldapd

cat ${download_folder}/nslcd.conf > /etc/nslcd.conf
sed -i "/uri ldap:\/\/<LDAP_ADDRESS>\//c\uri ldap:\/\/${sms_ip}\/" /etc/nslcd.conf
sed -i "/base <DOMAIN>/c\base ${lico_ldap_domain_name}" /etc/nslcd.conf
sed -i "/rootpwmoddn uid=admin,<DOMAIN>/c\rootpwmoddn uid=admin,${lico_ldap_domain_name}" /etc/nslcd.conf


cp /etc/nslcd.conf /install/installer/nslcd.conf
/opt/confluent/bin/nodeshell all cp /install/installer/nslcd.conf /etc/nslcd.conf
chmod 600 /etc/nslcd.conf
/opt/confluent/bin/nodeshell all chmod 600 /etc/nslcd.conf

systemctl enable nslcd --now
/opt/confluent/bin/nodeshell all systemctl enable nslcd --now


# Install authselect-nslcd-config
mkdir -p /usr/share/authselect/vendor/nslcd
/opt/confluent/bin/nodeshell all mkdir -p /usr/share/authselect/vendor/nslcd

cp ${download_folder}/${auth_select_files} /install/installer

tar -xzvf /install/installer/authselect.tar.gz -C /usr/share/authselect/vendor/nslcd/

/opt/confluent/bin/nodeshell all dnf install -y tar
/opt/confluent/bin/nodeshell all tar -xzvf /install/installer/authselect.tar.gz -C \
/usr/share/authselect/vendor/nslcd/

authselect select nslcd with-mkhomedir --force
/opt/confluent/bin/nodeshell all authselect select nslcd with-mkhomedir --force


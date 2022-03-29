source ./files/lico_env.local

dnf install -y nfs-utils
systemctl enable nfs-server --now

share_installer_dir="/install/installer"

echo "/install/installer *(rw,async,no_subtree_check,no_root_squash)" >> /etc/exports
exportfs -a

/opt/confluent/bin/nodeshell all dnf install -y nfs-utils
/opt/confluent/bin/nodeshell all systemctl enable nfs-client --now

/opt/confluent/bin/nodeshell all mkdir -p $share_installer_dir
/opt/confluent/bin/nodeshell all "echo '${sms_ip}:/install/installer /install/installer \
nfs nfsvers=4.0,nodev,nosuid,noatime 0 0' >> /etc/fstab"

/opt/confluent/bin/nodeshell all mount /install/installer


cat << eof > /etc/httpd/conf.d/installer.conf
Alias /install /install
<Directory /install>
AllowOverride None
Require all granted
Options +Indexes +FollowSymLinks
</Directory>
eof
systemctl restart httpd
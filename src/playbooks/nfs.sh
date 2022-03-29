source ./files/lico_env.local

# setup nfs
dnf install -y nfs-utils
systemctl enable nfs-server --now

/opt/confluent/bin/nodeshell all dnf install -y nfs-utils


# setup the install dir
share_installer_dir="/install/installer"

echo "/install/installer *(rw,async,no_subtree_check,no_root_squash)" >> /etc/exports
exportfs -a

/opt/confluent/bin/nodeshell all mkdir -p $share_installer_dir
/opt/confluent/bin/nodeshell all "echo '${sms_ip}:/install/installer /install/installer \
nfs nfsvers=4.0,nodev,nosuid,noatime 0 0' >> /etc/fstab"

/opt/confluent/bin/nodeshell all mount /install/installer

# setup httpd for install dir
cat << eof > /etc/httpd/conf.d/installer.conf
Alias /install /install
<Directory /install>
AllowOverride None
Require all granted
Options +Indexes +FollowSymLinks
</Directory>
eof
systemctl restart httpd


# setup the shared folder for all nodes
echo "/home *(rw,async,no_subtree_check,fsid=10,no_root_squash)" >> /etc/exports
exportfs -a

/opt/confluent/bin/nodeshell all "sed -i '/ \/home /d' /etc/fstab"
/opt/confluent/bin/nodeshell all umount /home

/opt/confluent/bin/nodeshell all echo "\""${sms_ip}:/home /home nfs nfsvers=4.0,nodev,nosuid,noatime \
0 0"\"" \>\> /etc/fstab

/opt/confluent/bin/nodeshell all mount /home 
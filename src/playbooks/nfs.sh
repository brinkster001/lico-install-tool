source ${download_folder}/lico_env.local


# because the default Centos 8.4 repos are not available anymore on their website
# we need to replace the default repos with our local repo to install nfs-utils on the nodes

for ((i=0; i<$num_computes; i++)); do
scp /install/installer/EL8-OS.repo root@${c_name[$i]}:/etc/yum.repos.d/EL8-OS.repo
done

if [ $num_logins -gt 0 ]
then
for ((i=0; i<$num_logins; i++)); do
scp /install/installer/EL8-OS.repo root@${l_name[$i]}:/etc/yum.repos.d/EL8-OS.repo
done
fi

# clean the repositories first
/opt/confluent/bin/nodeshell all rm -rf /etc/yum.repos.d/CentOS-Linux-*
/opt/confluent/bin/nodeshell all dnf clean all
/opt/confluent/bin/nodeshell all dnf makecache

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

# setup nfs
dnf install -y nfs-utils
systemctl enable nfs-server --now


# setup nfs-utils on the nodes
/opt/confluent/bin/nodeshell all dnf install -y nfs-utils


# setup the install dir
share_installer_dir="/install/installer"

echo "/install/installer *(rw,async,no_subtree_check,no_root_squash)" >> /etc/exports
exportfs -a

/opt/confluent/bin/nodeshell all mkdir -p $share_installer_dir
/opt/confluent/bin/nodeshell all "echo '${sms_ip}:/install/installer /install/installer \
nfs nfsvers=4.0,nodev,nosuid,noatime 0 0' >> /etc/fstab"

/opt/confluent/bin/nodeshell all mount /install/installer

# setup the shared folder for all nodes
echo "/home *(rw,async,no_subtree_check,fsid=10,no_root_squash)" >> /etc/exports
exportfs -a

/opt/confluent/bin/nodeshell all "sed -i '/ \/home /d' /etc/fstab"
/opt/confluent/bin/nodeshell all umount /home

/opt/confluent/bin/nodeshell all echo "\""${sms_ip}:/home /home nfs nfsvers=4.0,nodev,nosuid,noatime \
0 0"\"" \>\> /etc/fstab

/opt/confluent/bin/nodeshell all mount /home 
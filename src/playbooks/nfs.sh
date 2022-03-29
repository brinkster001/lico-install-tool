source ./files/lico_env.local

# Configure NFS

echo "/opt/ohpc/pub *(ro,no_subtree_check,fsid=11)">> /etc/exports
exportfs -a 

/opt/confluent/bin/nodeshell all dnf install -y nfs-utils

/opt/confluent/bin/nodeshell all mkdir -p /opt/ohpc/pub
/opt/confluent/bin/nodeshell all echo "\""${sms_ip}:/opt/ohpc/pub /opt/ohpc/pub nfs nfsvers=4.0,nodev,noatime \
0 0"\"" \>\> /etc/fstab

/opt/confluent/bin/nodeshell all mount /opt/ohpc/pub

echo "/home *(rw,async,no_subtree_check,fsid=10,no_root_squash)" >> /etc/exports
exportfs -a

/opt/confluent/bin/nodeshell all "sed -i '/ \/home /d' /etc/fstab"
/opt/confluent/bin/nodeshell all umount /home

/opt/confluent/bin/nodeshell all echo "\""${sms_ip}:/home /home nfs nfsvers=4.0,nodev,nosuid,noatime \
0 0"\"" \>\> /etc/fstab

/opt/confluent/bin/nodeshell all mount /home 
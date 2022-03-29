dnf module reset nginx
dnf module enable -y nginx:1.16

# Enable nginx for other nodes
/opt/confluent/bin/nodeshell all dnf module reset nginx
/opt/confluent/bin/nodeshell all dnf module enable -y nginx:1.16
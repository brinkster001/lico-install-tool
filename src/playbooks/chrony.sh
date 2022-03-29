# Configure Chrony
dnf install -y chrony
systemctl enable chronyd --now

/opt/confluent/bin/nodeshell all dnf install -y chrony
/opt/confluent/bin/nodeshell all systemctl enable chronyd --now
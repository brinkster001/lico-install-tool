# adjust memory limits
echo '* soft memlock unlimited' >> /etc/security/limits.conf
echo '* hard memlock unlimited' >> /etc/security/limits.conf

/opt/confluent/bin/nodeshell all echo "\""* soft memlock unlimited"\"" \>\> /etc/security/limits.conf
/opt/confluent/bin/nodeshell all echo "\""* hard memlock unlimited"\"" \>\> /etc/security/limits.conf

# disable the firewall
if [ "${disable_firewalld,,}" == "true" ]
then
systemctl disable firewalld --now
/opt/confluent/bin/nodeshell all systemctl disable firewalld --now
fi

# disable SELinux
if [ "${disable_selinux,,}" == "true" ]
then
setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config
/opt/confluent/bin/nodeshell all setenforce 0
/opt/confluent/bin/nodeshell all "sed -i 's/enforcing/disabled/' /etc/selinux/config"
fi


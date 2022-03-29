echo '* soft memlock unlimited' >> /etc/security/limits.conf
echo '* hard memlock unlimited' >> /etc/security/limits.conf

/opt/xcat/bin/xdcp all /etc/security/limits.conf /etc/security/limits.conf


if [ "${disable_firewalld,,}" == "true" ]
then
systemctl disable firewalld --now
#/opt/xcat/bin/psh all systemctl disable firewalld --now
fi

if [ "${disable_selinux,,}" == "true" ]
then
setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config
#/opt/xcat/bin/psh all setenforce 0
#/opt/xcat/bin/psh all "sed -i 's/enforcing/disabled/' /etc/selinux/config"
fi


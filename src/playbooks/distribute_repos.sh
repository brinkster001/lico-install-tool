/opt/confluent/bin/nodeshell all cp /install/installer/EL8-OS.repo /etc/yum.repos.d/
/opt/confluent/bin/nodeshell all cp /install/installer/lenovo-hpc.repo /etc/yum.repos.d/
/opt/confluent/bin/nodeshell all cp /install/installer/Lenovo.OpenHPC.local.repo /etc/yum.repos.d/
/opt/confluent/bin/nodeshell all cp /install/installer/lico-dep.repo /etc/yum.repos.d/
/opt/confluent/bin/nodeshell all cp /install/installer/lico-release.repo /etc/yum.repos.d/

/opt/confluent/bin/nodeshell all mkdir -p /root/repo_backup
/opt/confluent/bin/nodeshell all mv /etc/yum.repos.d/CentOS-* /root/repo_backup
/opt/confluent/bin/nodeshell all dnf clean all
/opt/confluent/bin/nodeshell all dnf makecache





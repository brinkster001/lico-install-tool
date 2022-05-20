source ${download_folder}/lico_env.local

# Install LiCO on the management node
dnf install -y lico-core lico-file-manager lico-confluent-proxy \
lico-vnc-proxy lico-icinga-mond lico-async-task lico-service-tool


if [ "${lico_vnc_proxy,,}" == "true" ]
then
dnf install -y lico-vnc-proxy
fi

if [ "${lico_mail_agent,,}" == "true" ]
then
dnf install -y lico-mail-agent
fi

if [ "${lico_sms_agent,,}" == "true" ]
then
dnf install -y lico-sms-agent
fi

if [ "${lico_wechat_agent,,}" == "true" ]
then
dnf install -y lico-wechat-agent
fi



systemctl restart confluent

# Install LiCO on the login node


if [ $num_logins -gt 0 ]
then
/opt/confluent/bin/nodeshell login dnf install -y lico-workspace-skeleton lico-portal lico-service-tool
else
dnf install -y lico-workspace-skeleton lico-portal
fi

# Install LiCO on the compute nodes
/opt/confluent/bin/nodeshell compute dnf install -y lico-ai-scripts

# Configure the LiCO internal key
/opt/confluent/bin/nodeshell all cp /install/installer/lico-auth-internal.key /etc/lico/lico-auth-internal.key

# Configure cluster nodes
cat ${download_folder}/nodes.csv > /etc/lico/nodes.csv

# Configure generic resources
cp /etc/lico/gres.csv.example /etc/lico/gres.csv

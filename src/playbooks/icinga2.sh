source ${download_folder}/lico_env.local


dnf install -y icinga2
/opt/confluent/bin/nodeshell all dnf install -y icinga2

dnf install -y nagios-plugins-ping
dnf install -y lico-icinga-plugin lico-job-icinga-plugin lico-monitor-module-slurm
/opt/confluent/bin/nodeshell all dnf install -y lico-icinga-plugin lico-job-icinga-plugin \
lico-monitor-module-slurm


icinga2 api setup

icinga2 node setup --master --disable-confd
echo -e "LANG=en_US.UTF-8" >> /etc/sysconfig/icinga2
systemctl restart icinga2


/opt/confluent/bin/nodeshell all icinga2 pki save-cert --trustedcert \
/var/lib/icinga2/certs/trusted-parent.crt --host ${sms_name}

for ((i=0;i<$num_computes;i++));do
ticket=`icinga2 pki ticket --cn ${c_name[${i}]}`
/opt/confluent/bin/nodeshell ${c_name[${i}]} icinga2 node setup --ticket ${ticket} --cn ${c_name[${i}]} \
--endpoint ${sms_name} --zone ${c_name[${i}]} --parent_zone master --parent_host \
${sms_name} --trustedcert /var/lib/icinga2/certs/trusted-parent.crt \
--accept-commands --accept-config --disable-confd
done


if [ $num_logins -gt 0 ]
then
for ((i=0;i<$num_logins;i++));do
ticket=`icinga2 pki ticket --cn ${l_name[${i}]}`
/opt/confluent/bin/nodeshell ${l_name[${i}]} icinga2 node setup --ticket ${ticket} --cn ${l_name[${i}]} \
--endpoint ${sms_name} --zone ${l_name[${i}]} --parent_zone master --parent_host \
${sms_name} --trustedcert /var/lib/icinga2/certs/trusted-parent.crt \
--accept-commands --accept-config --disable-confd
done
else
echo "no login nodes"
fi




/opt/confluent/bin/nodeshell all "echo -e 'LANG=en_US.UTF-8' >> /etc/sysconfig/icinga2"
/opt/confluent/bin/nodeshell all systemctl restart icinga2


mkdir -p /etc/icinga2/zones.d/global-templates

echo -e "object CheckCommand \"lico_monitor\" {\n command = [ PluginDir + \"/lico-\
icinga-plugin\" ]\n}" > /etc/icinga2/zones.d/global-templates/commands.conf

echo -e "object CheckCommand \"lico_job_monitor\" {\n command = [ PluginDir + \"/lico-\
job-icinga-plugin\" ]\n}" >> /etc/icinga2/zones.d/global-templates/commands.conf

echo -e "object CheckCommand \"lico_check_procs\" {\n command = [ \"ps\" ]\n \
arguments = {\n \"-eo\" = \"pid,user,pcpu,pmem,etime,cmd\",\n \"--no-\
headers\" = {}\n }\n}" >> /etc/icinga2/zones.d/global-templates/commands.conf


chown -R icinga:icinga /etc/icinga2/zones.d/global-templates

mkdir -p /etc/icinga2/zones.d/master


echo -e "object Host \"${sms_name}\" {\n check_command = \"hostalive\"\n \
address = \"${sms_ip}\"\n vars.agent_endpoint = name\n}\n" >> \
/etc/icinga2/zones.d/master/hosts.conf

for ((i=0;i<$num_computes;i++));do
echo -e "object Endpoint \"${c_name[${i}]}\" {\n host = \"${c_name[${i}]}\"\n \
port = \"${icinga_api_port}\"\n log_duration = 0\n}\nobject \
Zone \"${c_name[${i}]}\" {\n endpoints = [ \"${c_name[${i}]}\" ]\n \
parent = \"master\"\n}\n" >> /etc/icinga2/zones.d/master/agent.conf
echo -e "object Host \"${c_name[${i}]}\" {\n check_command = \"hostalive\"\n \
address = \"${c_ip[${i}]}\"\n vars.agent_endpoint = name\n}\n" >> \
/etc/icinga2/zones.d/master/hosts.conf
done

for ((i=0;i<$num_logins;i++));do
echo -e "object Endpoint \"${l_name[${i}]}\" {\n host = \"${l_name[${i}]}\"\n \
port = \"${icinga_api_port}\"\n log_duration = 0\n}\nobject \
Zone \"${l_name[${i}]}\" {\n endpoints = [ \"${l_name[${i}]}\" ]\n \
parent = \"master\"\n}\n" >> /etc/icinga2/zones.d/master/agent.conf
echo -e "object Host \"${l_name[${i}]}\" {\n check_command = \"hostalive\"\n \
address = \"${l_ip[${i}]}\"\n vars.agent_endpoint = name\n}\n" >> \
/etc/icinga2/zones.d/master/hosts.conf
done

echo -e "apply Service \"lico\" {\n check_command = \"lico_monitor\"\n \
max_check_attempts = 5\n check_interval = 1m\n retry_interval = 30s\n assign \
where host.name == \"${sms_name}\"\n assign where host.vars.agent_endpoint\n \
command_endpoint = host.vars.agent_endpoint\n}\n" > \
/etc/icinga2/zones.d/master/service.conf

echo -e "apply Service \"lico-procs-service\" {\n check_command = \"lico_\
check_procs\"\n enable_active_checks = false\n assign where \
host.name == \"${sms_name}\"\n assign where host.vars.agent_endpoint\n \
command_endpoint = host.vars.agent_endpoint\n}\n" >> \
/etc/icinga2/zones.d/master/service.conf

echo -e "apply Service \"lico-job-service\" {\n check_command = \"lico_job_monitor\"\n \
max_check_attempts = 5\n check_interval = 1m\n retry_interval = 30s\n assign \
where host.name == \"${sms_name}\"\n assign where host.vars.agent_endpoint\n \
command_endpoint = host.vars.agent_endpoint\n}\n" >> \
/etc/icinga2/zones.d/master/service.conf

chown -R icinga:icinga /etc/icinga2/zones.d/master
systemctl restart icinga2

/opt/confluent/bin/nodeshell all modprobe ipmi_devintf
/opt/confluent/bin/nodeshell all systemctl enable icinga2
modprobe ipmi_devintf
systemctl enable icinga2

icinga2 daemon -C
source ./files/lico_env.local

# Install Confluent
dnf install -y lenovo-confluent tftp-server
systemctl enable confluent --now
systemctl enable tftp.socket --now
systemctl enable httpd --now

# Create confluent account
source /etc/profile.d/confluent_env.sh
confetty create /users/${LICO_CONFLUENT_USERNAME} password=${LICO_CONFLUENT_PASSWORD} role=admin

nodegroupattrib everything deployment.useinsecureprotocols=firmware \
console.method=ipmi dns.servers=$dns_server dns.domain=$domain_name \
net.ipv4_gateway=$ipv4_gateway net.ipv4_method="static"


# nodegroupattrib everything -p bmcuser bmcpass crypted.rootpassword

# Define the management node in the lico_env.local file to confluent
nodegroupdefine all
nodegroupdefine login
nodegroupdefine compute
nodedefine $sms_name
nodeattrib $sms_name net.hwaddr=$sms_mac
nodeattrib $sms_name net.ipv4_address=$sms_ip
nodeattrib $sms_name hardwaremanagement.manager=$sms_bmc

# Define the compute node configuration to confluent

for ((i=0; i<$num_computes; i++)); do
nodedefine ${c_name[$i]};
nodeattrib ${c_name[$i]} net.hwaddr=${c_mac[$i]};
nodeattrib ${c_name[$i]} net.ipv4_address=${c_ip[$i]};
nodeattrib ${c_name[$i]} hardwaremanagement.manager=${c_bmc[$i]};
nodedefine ${c_name[$i]} groups=all,compute;
done

# Define the login node configuration to confluent
if [ $num_logins -gt 0 ]
for ((i=0; i<$num_logins; i++)); do
nodedefine ${l_name[$i]};
nodeattrib ${l_name[$i]} net.hwaddr=${l_mac[$i]};
nodeattrib ${l_name[$i]} net.ipv4_address=${l_ip[$i]};
nodeattrib ${l_name[$i]} hardwaremanagement.manager=${l_bmc[$i]};
nodedefine ${l_name[$i]} groups=all,login;
done
fi
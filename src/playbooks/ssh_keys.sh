source ${download_folder}/lico_env.local

dnf install -y expect


# generate a new key 
FILE=/root/.ssh/id_rsa

if test -f "$FILE"
then
    echo "$FILE already exists."
else
ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -N ''
fi

# copy the key to the nodes
for ((i=0; i<$num_computes; i++)); do
expect $(pwd)/src/playbooks/ssh_keys.expect root@${c_name[$i]} ${LICO_ROOT_PASSWORD}
done

# and also copy to the login nodes
if [ $num_logins -gt 0 ]
then
for ((i=0; i<$num_logins; i++)); do
expect $(pwd)/src/playbooks/ssh_keys.expect root@${l_name[$i]} ${LICO_ROOT_PASSWORD}
done
fi


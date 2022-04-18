source ${download_folder}/lico_env.local

# Install Slurm
dnf install -y lenovo-ohpc-base
dnf install -y ohpc-slurm-server
/opt/confluent/bin/nodeshell all dnf install -y ohpc-base-compute ohpc-slurm-client lmod-ohpc


# Configure Slurm
cat ${download_folder}/slurm.conf > /etc/slurm/slurm.conf



sed -i "/SlurmctldHost=c031/c\SlurmctldHost=${sms_name}" /etc/slurm/slurm.conf
sed -i "/NodeName=c031 Gres=gpu:4 CPUs=28 RealMemory=200000 State=UNKNOWN/c\#NodeName=c031 Gres=gpu:4 CPUs=28 RealMemory=200000 State=UNKNOWN" /etc/slurm/slurm.conf
sed -i "/NodeName=c032 Gres=gpu:4 CPUs=28 RealMemory=200000 State=UNKNOWN/c\#NodeName=c032 Gres=gpu:4 CPUs=28 RealMemory=200000 State=UNKNOWN" /etc/slurm/slurm.conf
sed -i "/PartitionName=compute/c\#PartitionName=compute Nodes=c0[31-32] Default=YES  MaxTime=INFINITE State=UP" /etc/slurm/slurm.conf




for ((i=0; i<$num_computes; i++)); do
echo "NodeName=${c_name[$i]} CPUs=${c_cpu[$i]} RealMemory=${c_ram[$i]} State=UNKNOWN" >> /etc/slurm/slurm.conf
done

first=${c_name[0]}
last=${c_name[$num_computes]}

if [ $num_computes -gt 1 ]
then
echo "PartitionName=compute Nodes=${compute_prefix}[1-${num_computes}] Default=YES  MaxTime=INFINITE State=UP" >> /etc/slurm/slurm.conf
else
echo "PartitionName=compute Nodes=${compute_prefix}1 Default=YES  MaxTime=INFINITE State=UP" >> /etc/slurm/slurm.conf
fi





cat ${download_folder}/cgroup.conf > /etc/slurm/cgroup.conf

cp /etc/slurm/slurm.conf /install/installer
cp /etc/slurm/cgroup.conf /install/installer
cp /etc/munge/munge.key /install/installer

/opt/confluent/bin/nodeshell all cp /install/installer/slurm.conf /etc/slurm/slurm.conf
/opt/confluent/bin/nodeshell all cp /install/installer/cgroup.conf /etc/slurm/cgroup.conf
/opt/confluent/bin/nodeshell all cp /install/installer/munge.key /etc/munge/munge.key


systemctl enable munge
systemctl enable slurmctld
systemctl restart munge
systemctl restart slurmctld

/opt/confluent/bin/nodeshell all systemctl enable munge
/opt/confluent/bin/nodeshell all systemctl restart munge
/opt/confluent/bin/nodeshell all systemctl enable slurmd
/opt/confluent/bin/nodeshell all systemctl restart slurmd


# Configure NFS

echo "/opt/ohpc/pub *(ro,no_subtree_check,fsid=11)">> /etc/exports
exportfs -a 

/opt/confluent/bin/nodeshell all dnf install -y nfs-utils

/opt/confluent/bin/nodeshell all mkdir -p /opt/ohpc/pub
/opt/confluent/bin/nodeshell all echo "\""${sms_ip}:/opt/ohpc/pub /opt/ohpc/pub nfs nfsvers=4.0,nodev,noatime \
0 0"\"" \>\> /etc/fstab

/opt/confluent/bin/nodeshell all mount /opt/ohpc/pub
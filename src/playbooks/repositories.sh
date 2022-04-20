source ${download_folder}/lico_env.local

mkdir ${iso_path}
mkdir -p /install/installer
mkdir -p ${os_repo_dir}
mkdir -p /root/repo_backup


mv ${download_folder}/${iso} ${iso_path}
mount -o loop ${iso_path}/${iso} ${os_repo_dir}

mv /etc/yum.repos.d/CentOS-* /root/repo_backup


# OS repo - local
cat << eof > ${iso_path}/EL8-OS.repo
[AppStream]
name=appstream
baseurl=file://${os_repo_dir}/AppStream/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
[BaseOS]
name=baseos
baseurl=file://${os_repo_dir}/BaseOS/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
eof

cp -a ${iso_path}/EL8-OS.repo /etc/yum.repos.d/

# OS repo - nodes
cp /etc/yum.repos.d/EL8-OS.repo /install/installer/
sed -i '/^baseurl=/d' /install/installer//EL8-OS.repo
sed -i "/name=appstream/a\baseurl=http://${sms_name}${os_repo_dir}/AppStream/" \
/install/installer//EL8-OS.repo
sed -i "/name=baseos/a\baseurl=http://${sms_name}${os_repo_dir}/BaseOS/" \
/install/installer/EL8-OS.repo


# confluent repo - local
dnf install -y bzip2 tar
mkdir -p $confluent_repo_dir
cd /root
tar -xvf ${download_folder}/${lenovo_hpc_archive} -C $confluent_repo_dir
cd $confluent_repo_dir/lenovo-hpc-el8
./mklocalrepo.sh
cd ~

# confluent repo - nodes
cp /etc/yum.repos.d/lenovo-hpc.repo /install/installer/
sed -i '/^baseurl=/d' /install/installer//lenovo-hpc.repo
sed -i '/^gpgkey=/d' /install/installer//lenovo-hpc.repo

echo "baseurl=http://${sms_name}${confluent_repo_dir}/lenovo-hpc-el8" \
>> /install/installer//lenovo-hpc.repo

echo "gpgkey=http://${sms_name}${confluent_repo_dir}/lenovo-hpc-el8\
/lenovohpckey.pub" >> /install/installer//lenovo-hpc.repo


# OHPC repo - local
mkdir -p $ohpc_repo_dir
cd /root
tar xvf $download_folder/$ohpc_archive -C $ohpc_repo_dir
rm -rf $link_ohpc_repo_dir
ln -s $ohpc_repo_dir $link_ohpc_repo_dir
$link_ohpc_repo_dir/make_repo.sh

# OHPC repo - nodes

# cp /etc/yum.repos.d/Lenovo.OpenHPC.local.repo /install/installer/
# sed -i '/^baseurl=/d' /install/installer//Lenovo.OpenHPC.local.repo
# sed -i '/^gpgkey=/d' /install/installer//Lenovo.OpenHPC.local.repo
# echo "baseurl=http://${sms_name}${link_ohpc_repo_dir}/CentOS_8" \
# >> /install/installer//Lenovo.OpenHPC.local.repo
# echo "gpgkey=http://${sms_name}${link_ohpc_repo_dir}/CentOS_8\
# /repodata/repomd.xml.key" >> /install/installer//Lenovo.OpenHPC.local.repo

cp /etc/yum.repos.d/Lenovo.OpenHPC.local.repo /install/installer//
sed -i '/^baseurl=/d' /install/installer//Lenovo.OpenHPC.local.repo
sed -i '/^gpgkey=/d' /install/installer//Lenovo.OpenHPC.local.repo
echo "baseurl=http://${sms_name}${link_ohpc_repo_dir}/CentOS_8" \
>> /install/installer//Lenovo.OpenHPC.local.repo
echo "gpgkey=http://${sms_name}${link_ohpc_repo_dir}/CentOS_8\
/repodata/repomd.xml.key" >> /install/installer//Lenovo.OpenHPC.local.repo

# lico-dep repo - local
mkdir -p $lico_dep_repo_dir
tar -xvf $download_folder/$lico_dep_archive -C $lico_dep_repo_dir
rm -rf $link_lico_dep_repo_dir
ln -s $lico_dep_repo_dir $link_lico_dep_repo_dir
$link_lico_dep_repo_dir/mklocalrepo.sh

# lico-dep repo - nodes
cp /etc/yum.repos.d/lico-dep.repo /install/installer//
sed -i '/^baseurl=/d' /install/installer//lico-dep.repo
sed -i '/^gpgkey=/d' /install/installer//lico-dep.repo
sed -i "/name=lico-dep-local-library/a\baseurl=http://${sms_name}\
${link_lico_dep_repo_dir}/library/" /install/installer//lico-dep.repo
sed -i "/name=lico-dep-local-library/a\gpgkey=http://${sms_name}\
${link_lico_dep_repo_dir}/RPM-GPG-KEY-LICO-DEP-EL8" /install/installer//lico-dep.repo
sed -i "/name=lico-dep-local-standalone/a\baseurl=http://${sms_name}\
${link_lico_dep_repo_dir}/standalone/" /install/installer//lico-dep.repo
sed -i "/name=lico-dep-local-standalone/a\gpgkey=http://${sms_name}\
${link_lico_dep_repo_dir}/RPM-GPG-KEY-LICO-DEP-EL8" /install/installer//lico-dep.repo


# lico-release repo - local
mkdir -p $lico_repo_dir
tar zxvf $download_folder/$lico_release_archive -C $lico_repo_dir --strip-components 1
rm -rf $link_lico_repo_dir
ln -s $lico_repo_dir $link_lico_repo_dir
$link_lico_repo_dir/mklocalrepo.sh

# lico-release repo - nodes
cp /etc/yum.repos.d/lico-release.repo /install/installer/
sed -i '/baseurl=/d' /install/installer//lico-release.repo
sed -i "/name=lico-release-host/a\baseurl=http://${sms_name}\
${link_lico_repo_dir}/host/" /install/installer//lico-release.repo
sed -i "/name=lico-release-public/a\baseurl=http://${sms_name}\
${link_lico_repo_dir}/public/" /install/installer//lico-release.repo

# update dnf cache
rm -rf /etc/yum.repos.d/CentOS-Linux-*
dnf clean all
dnf makecache


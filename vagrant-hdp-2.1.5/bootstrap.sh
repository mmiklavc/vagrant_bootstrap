#!/bin/bash

echo 'Updating yum & installing software'
sudo yum -y update
sudo yum -y install redhat-lsb vim java-1.7.0-openjdk-devel.x86_64 mlocate ntp ntpdate ntp-doc
echo 'Done installs'

echo "Installing Maven"
cd /tmp/
wget http://apache.cs.utah.edu/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.tar.gz
tar zxvf apache-maven-3.2.3-bin.tar.gz -C /usr/local
cd /usr/local
ln -s apache-maven-3.2.3 maven
cp /vagrant/maven.sh /etc/profile.d/
echo "Done Maven"

echo 'Updating mlocate db'
updatedb
echo 'Done mlocate'

# ntp config
echo 'Enabling ntp'
chkconfig ntpd on
ntpdate pool.ntp.org
/etc/init.d/ntpd start
echo 'Done ntp'

# copy files
echo 'Copying files'
cp /vagrant/.bashrc /root/
cp /vagrant/.vimrc /root/
cp -R /vagrant/.ssh /root/
echo 'Done copying files'

# setup ssh keys
echo 'Setting permissions on ssh keys'
chmod 700 /root/.ssh
chmod 600 /root/.ssh/auhorized_keys
echo 'Done ssh keys'

# iptables
echo 'Turning off iptables'
chkconfig iptables off
/etc/init.d/iptables stop
echo 'Done iptables'

# disable SELinux
echo 'Disabling SELinux'
setenforce 0
echo 'Done SELinux'

# Ambari repos
echo 'Getting Ambari repos'
wget http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo -O /etc/yum.repos.d/ambari.repo
echo 'Done Ambari repos'

# HDP repos
echo 'Getting HDP repos'
wget http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.1.5.0/hdp.repo -O /etc/yum.repos.d/hdp.repo
echo 'Done HDP repos'


#!/usr/bin/env bash

yum update
yum -y remove java-1.7.0-openjdk

yum -y install figlet jq make mysql mysql-client vim bzip2 curl git htop iftop inotify-tools iotop lsof lzop netcat net-tools ntp python-pip python-selinux screen strace tcpdump tcptraceroute telnet tree unzip wget
wget -O /tmp/jdk-8u141-linux-x64.rpm --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.rpm
yum install -y /tmp/jdk-8u141-linux-x64.rpm

alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_141/bin/java 2

# Generate system banner
figlet "${welcome_message}" > /etc/motd

##
## Setup SSH Config
##
cat <<"__EOF__" > /home/${ssh_user}/.ssh/config
Host *
    StrictHostKeyChecking no
__EOF__
chmod 600 /home/${ssh_user}/.ssh/config
chown ${ssh_user}:${ssh_user} /home/${ssh_user}/.ssh/config

# Setup default `make` support
echo 'alias make="make -C /usr/local/include --no-print-directory"' >> /etc/skel/.bash_aliases
cp /etc/skel/.bash_aliases /root/.bash_aliases
cp /etc/skel/.bash_aliases /home/${ssh_user}/.bash_aliases

echo 'default:: help' > /usr/local/include/Makefile
echo '-include Makefile.*' >> /usr/local/include/Makefile

aws configure set region ${region}
echo ${public_key} >> /home/${ssh_user}/.ssh/authorized_keys


# Determine whether there's a file system on the attached volume /dev/xvdj
file -s ${device_name} | grep "grep cannot"
result=$(file -s "${device_name}")

if [[ "$result" == "${device_name}: data" ]]
then
  echo "there's no file system on the device - so create it before mounting"
  mkfs -t xfs "${device_name}"
  mkdir -p ${jenkins_mount_dir}
  mount ${device_name} ${jenkins_mount_dir}
  wget -O  ${jenkins_mount_dir}/jenkins/jenkins.war https://updates.jenkins-ci.org/download/war/2.194/jenkins.war
  mkdir -p "${jenkins_mount_dir}/jenkins/plugins"
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/blueocean.hpl https://updates.jenkins-ci.org/download/plugins/blueocean/1.19.0/blueocean.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/build-pipeline-plugin.hpl https://updates.jenkins-ci.org/download/plugins/build-pipeline-plugin/1.5.8/build-pipeline-plugin.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/ssh.hpl https://updates.jenkins-ci.org/download/plugins/ssh/2.6.1/ssh.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/ssh-slaves.hpl https://updates.jenkins-ci.org/download/plugins/ssh-slaves/1.30.1/ssh-slaves.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/ssh-agent.hpl https://updates.jenkins-ci.org/download/plugins/ssh-agent/1.17/ssh-agent.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/multibranch-scan-webhook-trigger.hpl https://updates.jenkins-ci.org/download/plugins/multibranch-scan-webhook-trigger/1.0.5/multibranch-scan-webhook-trigger.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/generic-webhook-trigger.hpl https://updates.jenkins-ci.org/download/plugins/generic-webhook-trigger/1.57/generic-webhook-trigger.hpi
else
  echo "file system exists - so mount it"
  mkdir -p ${jenkins_mount_dir}
  mount ${device_name} ${jenkins_mount_dir}
fi

#update /etc/fstab
cp /etc/fstab /etc/fstab.orig
ID=$(blkid | grep "${device_name}" | awk '{print $2}'| tr -d \")
echo "$ID   ${jenkins_mount_dir}  xfs defaults,nofail 0   2" >> /etc/fstab
#touch ${jenkins_mount_dir}/it_works

groupadd jenkins
useradd -g jenkins jenkins
echo "export JENKINS_HOME=${jenkins_mount_dir}/jenkins" >>/home/jenkins/.bashrc

chown -R jenkins:jenkins "${jenkins_mount_dir}/jenkins"

cat <<"__EOF__" > /etc/systemd/system/jenkins.service
[Unit]
Description=Jenkins Daemon

[Service]
ExecStart=/usr/bin/java -jar ${jenkins_mount_dir}/jenkins/jenkins.war
User=jenkins

[Install]
WantedBy=multi-user.target

__EOF__

systemctl daemon-reload
systemctl start jenkins.service
systemctl enable jenkins.service


${user_data}


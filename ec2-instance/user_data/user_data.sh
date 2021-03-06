#!/usr/bin/env bash

yum update
yum -y remove java-1.7.0-openjdk

yum -y install wget
wget -O /tmp/jdk-8u141-linux-x64.rpm --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.rpm
yum install -y /tmp/jdk-8u141-linux-x64.rpm

alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_141/bin/java 2


# Determine whether there's a file system on the attached volume /dev/xvdj
file -s ${device_name} | grep "grep cannot"
result=$(file -s "${device_name}")

if [[ "$result" == "${device_name}: data" ]]
then
  echo "there's no file system on the device - so create it before mounting"
  mkfs -t xfs "${device_name}"
  mkdir -p ${jenkins_mount_dir}
  mount ${device_name} ${jenkins_mount_dir}
  mkdir -p "${jenkins_mount_dir}/jenkins/plugins"
  wget -O  ${jenkins_mount_dir}/jenkins/jenkins.war https://updates.jenkins-ci.org/download/war/2.194/jenkins.war
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/blueocean.hpl https://updates.jenkins-ci.org/download/plugins/blueocean/1.19.0/blueocean.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/blueocean-github-pipeline.hpl https://updates.jenkins-ci.org/download/plugins/blueocean-github-pipeline/1.19.0/-github-pipelineblueocean.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/build-pipeline-plugin.hpl https://updates.jenkins-ci.org/download/plugins/build-pipeline-plugin/1.5.8/build-pipeline-plugin.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/ssh.hpl https://updates.jenkins-ci.org/download/plugins/ssh/2.6.1/ssh.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/ssh-slaves.hpl https://updates.jenkins-ci.org/download/plugins/ssh-slaves/1.30.1/ssh-slaves.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/ssh-agent.hpl https://updates.jenkins-ci.org/download/plugins/ssh-agent/1.17/ssh-agent.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/multibranch-scan-webhook-trigger.hpl https://updates.jenkins-ci.org/download/plugins/multibranch-scan-webhook-trigger/1.0.5/multibranch-scan-webhook-trigger.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/generic-webhook-trigger.hpl https://updates.jenkins-ci.org/download/plugins/generic-webhook-trigger/1.57/generic-webhook-trigger.hpi
  wget -O  ${jenkins_mount_dir}/jenkins/plugins/aws-secrets-manager-credentials-provider.hpl https://updates.jenkins-ci.org/download/plugins/aws-secrets-manager-credentials-provider/0.0.1/aws-secrets-manager-credentials-provider.hpi
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


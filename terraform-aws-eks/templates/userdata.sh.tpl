#!/bin/bash -xe

# Allow user supplied pre userdata code
${pre_userdata}

# we're using amazon default AMI for worker nodes
yum -y update
yum -y install nfs-utils

mkdir -p ${efs_mount_dir}
chmod -R 777 ${efs_mount_dir}

mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport '${efs_dns}:/' ${efs_mount_dir}


  # Bootstrap and join the cluster
/etc/eks/bootstrap.sh --enable-docker-bridge=true --b64-cluster-ca '${cluster_auth_base64}' --apiserver-endpoint '${endpoint}' ${bootstrap_extra_args} --kubelet-extra-args '${kubelet_extra_args}' '${cluster_name}'

# Allow user supplied userdata code
${additional_userdata}

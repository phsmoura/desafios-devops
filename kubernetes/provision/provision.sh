#!/bin/bash

# Add ssh keys on /root
mkdir -p /root/.ssh
cp /vagrant/files/id_rsa* /root/.ssh
chmod 400 /root/.ssh/id_rsa*
cp /vagrant/files/id_rsa.pub /root/.ssh/authorized_keys

# Add fqdn on /etc/hosts
HOSTS=$(head -n7 /etc/hosts)
echo -e "$HOSTS" > /etc/hosts
echo '192.168.10.10 master.k8s.com' >> /etc/hosts
echo '192.168.10.20 minion1.k8s.com' >> /etc/hosts

# Install docker-ce, kebernetes and setup daemon for container runtime
# see doc: https://kubernetes.io/docs/setup/production-environment/container-runtimes/
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common dirmngr vim telnet curl nfs-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo '{
	"exec-opts": ["native.cgroupdriver=systemd"],
	"log-driver": "json-file",
  	"log-opts": {
	  "max-size": "5m",
	  "max-file": "3"
  },
  "storage-driver": "overlay2"
}' > /etc/docker/daemon.json

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

# disable swap now and for good in /etc/fstab
sed -Ei 's/(.*swap.*)/#\1/g' /etc/fstab
swapoff -a
usermod -G docker -a vagrant

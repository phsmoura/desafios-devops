#!/bin/bash

# Add ssh keys on /root
mkdir -p /root/.ssh
cat /home/vagrant/kubernetes/ssh_keys/id_rsa.pub > /root/.ssh/authorized_keys
cat /home/vagrant/kubernetes/ssh_keys/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
cp /home/vagrant/kubernetes/ssh_keys/id_rsa /root/.ssh/
chmod 600 /root/.ssh/id_rsa
# cp /vagrant/id_rsa.pub /root/.ssh/authorized_keys

# Add fqdn on /etc/hosts
HOSTS=$(head -n7 /etc/hosts)
echo -e "$HOSTS" > /etc/hosts
echo '172.100.100.10 master.k8s.com master' >> /etc/hosts
echo '172.100.100.20 minion1.k8s.com minion1' >> /etc/hosts

# Install docker-ce, kubernetes and setup daemon for container runtime
# see doc: https://kubernetes.io/docs/setup/production-environment/container-runtimes/

# install dependencies
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common dirmngr vim telnet curl nfs-common

# add repo docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# add repo kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
add-apt-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"

## Install Docker CE.
apt-get update
apt-get install -y containerd.io=1.2.13-1 docker-ce=5:19.03.8~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.8~3-0~ubuntu-$(lsb_release -cs)

# Setup daemon.
echo '{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}' > /etc/docker/daemon.json

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

# install kubernetes
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# disable swap now and for good in /etc/fstab
sed -Ei 's/(.*swap.*)/#\1/g' /etc/fstab
swapoff -a
usermod -G docker -a vagrant

# applying bash completion for kubectl
echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc

# because the lack of a registry building app image in all nodes
# implement registry later
docker image build --tag=app:1.0 /home/vagrant/kubernetes/
# docker tag app:1.0 app
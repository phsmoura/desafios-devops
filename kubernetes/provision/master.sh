#!/bin/bash

# configure master before initialize cluster
# kubeadm config images pull
# echo "KUBELET_EXTRA_ARGS='--node-ip=172.100.100.$1'" > /etc/default/kubelet

# init kubernetes cluster
kubeadm init --apiserver-advertise-address=172.100.100.10 --pod-network-cidr=10.244.0.0/16
mkdir -p ~/.kube
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant: /home/vagrant/.kube

# get calico for pod communication to different nodes
curl -s https://docs.projectcalico.org/v3.10/manifests/calico.yaml > /root/calico.yml
sed -i 's?192.168.0.0/16?10.244.0.0/16?g' /root/calico.yml
kubectl apply -f /root/calico.yml

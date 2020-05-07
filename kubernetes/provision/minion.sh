#!/bin/bash

# entering cluster
echo "KUBELET_EXTRA_ARGS='--node-ip=192.168.10.$1'" > /etc/default/kubelet
$(ssh -o stricthostkeychecking=no 192.168.10.10 kubeadm token create --print-join-command)

# building app image
docker image build --tag=app:1.0 /home/vagrant/kubernetes/

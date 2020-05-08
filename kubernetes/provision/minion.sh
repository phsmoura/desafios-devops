#!/bin/bash

# entering cluster
echo "KUBELET_EXTRA_ARGS='--node-ip=172.100.100.$1'" > /etc/default/kubelet
$(ssh -o stricthostkeychecking=no 172.100.100.10 kubeadm token create --print-join-command)

# building app image
docker image build --tag=app:1.0 /home/vagrant/kubernetes/
docker image tag app:1.0 app

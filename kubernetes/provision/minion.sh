#!/bin/bash

echo "KUBELET_EXTRA_ARGS='--node-ip=190.168.10.$1'" > /etc/default/kubelet
$(ssh -o stricthostkeychecking=no 190.168.10.10 kubeadm token create --print-join-command)

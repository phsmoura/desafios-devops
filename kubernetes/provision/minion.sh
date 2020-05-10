#!/bin/bash

# entering cluster
# echo "KUBELET_EXTRA_ARGS='--node-ip=172.100.100.$1'" > /etc/default/KUBELET_EXTRA_ARGSt
$(ssh -o stricthostkeychecking=no 172.100.100.10 kubeadm token create --print-join-command)

# deploying registry server
# docker run -d -p 5000:5000 --restart=always --name registry registry:2

# building app image and push to registry
# docker image build --tag=app:1.0 /home/vagrant/kubernetes/
# docker tag app:1.0 localhost:5000/app
# docker push localhost:5000/app

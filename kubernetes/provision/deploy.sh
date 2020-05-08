#!/bin/bash

function print_help {
	echo "Usage: ./deploy.sh [--all|--namespace|--service|--deploy] [--wait]

Mandatory arguments:
--all		apply namespace, service and deployment
--namespaces	apply only namespace
--service	apply only service
--deploy	apply only deployment

Not mandatory options:
--wait	wait 20 seconds before applying changes
--help	show this option
"
}

if [ $# -ne 2 ]
then
	print_help
	exit
fi

# wait for minion to get ready on cluster
if [ $2 == "--wait" ]
then
	sleep 20
fi

case $1 in
  --all)
  kubectl apply -f /home/vagrant/kubernetes/manifests/app-namespace
  kubectl apply -f /home/vagrant/kubernetes/manifests/app-service
  kubectl apply -f /home/vagrant/kubernetes/manifests/app-deployment
  # kubectl apply -f /home/vagrant/kubernetes/manifests/app-ingress
  ;;

	--namespace)
	kubectl apply -f /home/vagrant/kubernetes/manifests/app-namespace
	;;

	--service)
	kubectl apply -f /home/vagrant/kubernetes/manifests/app-service
	;;

	--deploy)
	kubectl apply -f /home/vagrant/kubernetes/manifests/app-deployment
	;;

	--help)
	print_help
	;;

  *)
	echo "
	Invalid option!"
	print_help
  ;;
esac

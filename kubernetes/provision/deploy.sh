#!/bin/bash

DIR_MANIFESTS="/home/vagrant/kubernetes/manifests"

function print_help {
	echo "Usage: ./deploy.sh [--all|--namespace|--service|--deployment]

Option arguments:
--all		apply namespace, service and deployment
--namespaces	apply only namespace
--service	apply only service
--deployment	apply only deployment
--help	show this option
"
}

if [ $# -gt 1 ]
then
	print_help
	exit
fi

case $1 in
  --all)
  kubectl apply -f $DIR_MANIFESTS/app-namespace.yml
  kubectl apply -f $DIR_MANIFESTS/app-service.yml
  kubectl apply -f $DIR_MANIFESTS/app-deployment.yml
  # kubectl apply -f /home/vagrant/kubernetes/manifests/app-ingress
  ;;

	--namespace)
	kubectl apply -f $DIR_MANIFESTS/app-namespace.yml
	;;

	--service)
	kubectl apply -f $DIR_MANIFESTS/app-service.yml
	;;

	--deployment)
	kubectl apply -f $DIR_MANIFESTS/app-deployment.yml
	;;

	--help)
	print_help
	;;

  *)
	echo "Invalid option!"
	print_help
  ;;
esac

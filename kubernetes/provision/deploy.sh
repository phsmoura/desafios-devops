#!/bin/bash

if [ $HOSTNAME != "master" ]
then
	echo "Must be the master node to execute this script.
	"
	exit
fi

DIR_MANIFESTS="/home/vagrant/kubernetes/manifests"

function print_help {
	echo "Usage: ./deploy.sh [--all|--namespace|--service|--deployment]

Option arguments:
--all		apply namespace, service and deployment
--namespaces	apply only namespace
--service	apply only service
--deployment	apply only deployment
--ingress	apply ingress
--help	show this option

Same if you want to delete:
--delete-all
--delete-namespace
--delete-service
--delete-deployment
--delete-ingress
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
	kubectl apply -f $DIR_MANIFESTS/app-ingress.yml
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

	--ingress)
	kubectl apply -f $DIR_MANIFESTS/app-ingress.yml
	;;

	--delete-all)
	kubectl delete -f $DIR_MANIFESTS/app-ingress.yml
	kubectl delete -f $DIR_MANIFESTS/app-service.yml
	kubectl delete -f $DIR_MANIFESTS/app-deployment.yml
	kubectl delete -f $DIR_MANIFESTS/app-namespace.yml
	;;

	--delete-namespace)
	kubectl delete -f $DIR_MANIFESTS/app-namespace.yml
	;;

	--delete-service)
	kubectl delete -f $DIR_MANIFESTS/app-service.yml
	;;

	--delete-deployment)
	kubectl delete -f $DIR_MANIFESTS/app-deployment.yml
	;;

	--delete-ingress)
	kubectl delete -f $DIR_MANIFESTS/app-ingress.yml
	;;

	--help)
	print_help
	;;

	*)
	echo "Invalid option!"
	print_help
	;;
esac

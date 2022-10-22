#!/bin/bash

#===============
# start minikube

minikube start

# minikube stop && minikube delete && rm -Rf $HOME/.minikube
# minikube start --cpus 4 --memory 8192 --kubernetes-version=v1.20.0 --vm-driver=virtualbox
# minikube start --kubernetes-version=v1.16.1 --vm-driver=hyperkit --cpus 4 --memory 8192 --show-libmachine-logs --v=10 --alsologtostderr
# minikube start --kubernetes-version=v1.21.11 --vm-driver=hyperkit --cpus 2 --memory 4096 --container-runtime=docker

#===============
# Set docker env in local shell
# eval $(minikube docker-env)             # unix shells
# eval $(minikube -p minikube docker-env) # unix shells
# minikube docker-env | Invoke-Expression # PowerShell
eval $(minikube -p minikube docker-env)

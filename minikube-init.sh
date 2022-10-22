#!/bin/bash

# ===============
# config

minikube config set cpus 2
minikube config set memory 4096
# minikube config set driver docker
minikube config set vm-driver hyperkit
minikube config set kubernetes-version v1.21.11
minikube config set container-runtime docker
#minikube config set WantVirtualBoxDriverWarning false
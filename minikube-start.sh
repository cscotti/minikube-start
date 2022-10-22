#!/bin/bash

#===============
# start minikube

minikube start

# minikube stop && minikube delete && rm -Rf $HOME/.minikube
# minikube start --cpus 4 --memory 8192 --kubernetes-version=v1.20.0 --vm-driver=virtualbox
# minikube start --kubernetes-version=v1.16.1 --vm-driver=hyperkit --cpus 4 --memory 8192 --show-libmachine-logs --v=10 --alsologtostderr
# minikube start --kubernetes-version=v1.21.11 --vm-driver=hyperkit --cpus 2 --memory 4096 --container-runtime=docker

# The Minikube recent update(v1.24.0) supports to start Minikube VM without starting any Kubernetes in it
# used the flag --no-kubernetes
# minikube config unset kubernetes-version
# minikube start --no-kubernetes --memory 4096 --cpus 2 --docker-opt=bip=172.17.42.1/16

# configure minikube cluster with new bridge ip
# minikube start --docker-opt=bip=172.17.42.1/16

#===============
# Set docker env in local shell
# eval $(minikube docker-env)             # unix shells
# eval $(minikube -p minikube docker-env) # unix shells
# minikube docker-env | Invoke-Expression # PowerShell
eval $(minikube -p minikube docker-env)




# ===============================
# Divers

# minikube ip
# minikube event
# minikube logs -f |grep example
# minikube update-check
# minikube ssh
# minikube dashboard
# minikube tunnel
# minikube service xxxx

# ===============================
# Image / Load and remove (new)

# minikube image load xxxx:latest
# minikube image list
# minikube image rm docker.io/library/xxxx:latest

# ===============================
# Image / Load and remove (old)

# minikube cache add xxxx:latest
# minikube cache list
# minikube cache reload
# minikube cache delete xxxx:latest


# *************************
# docker
# *************************


# ===============================
# docker run

# build
# docker build . -t test-build:latest

# start container
# docker stop test-build
# docker rm test-build
# docker run --name test-build -d test-build:latest bash -c "tail -f /dev/null"

# access to container prompt
# docker exec -it test-build /bin/sh

# restart container if stopped
# docker restart test-build

# container log
# docker logs test-build

# copy file
# docker exec test-build cp /source/file.txt /target/file.txt

# ===============================
# docker volume mount - option 1

# step 1- mount the disk on the laptop to the Hyperkit VM
# minikube mount /myvolume:/test

# step 2- run docker
# docker run --rm -it -v /test:/inside busybox /bin/sh

# ssh to minikube to view the volume /test
# minikube ssh

# ex 2
# minikube mount $(pwd)/workdir:/workdir
# docker run --name test-build -v /workdir:/workdir -d test-build:latest test-build

# ===============================
# docker Volume mount - option 2

# stop minikube
# minikube stop

# start minikube with volument mount
# minikube start --mount --mount-string="/private/var/services/:/private/var/services/"

# volume will be created inside the minikube vm
# docker run -d --name redis -p 6379:6379 -v /private/var/services/redis:/data redis:5.0.3

# ===============================
# docker Volume mount - option 3
# mac alternative - Volume mount (but can be also run under linux)
# https://github.com/kubernetes/minikube/issues/2481

# ssh-keygen -R $(minikube ip)
# scp -ri "$(minikube ssh-key)" "$PWD" docker@$(minikube ip):/tmp

# start container
# docker run --name node_build -v /tmp:/source -d ubuntu:22.10 bash -c "tail -f /dev/null"

#  ==============================
# Docker network

# docker network ls
# docker inspect bridge
# docker inspect bridge |jq '.[0].IPAM.Config[0].Gateway'
# docker port xxxx:latest


# When running standard docker compose commands you might need an additional port forward to access your containers
# ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip) -L '*:19088:0.0.0.0:19088' -N
# Hint: The first port is on the host, the second the post exposed by the container inside minikube.

# add minikube ip to /etc/hosts if want
# echo "`minikube ip` docker.local" | sudo tee -a /etc/hosts > /dev/null

# ===============================
# Docker build

# docker build -t myssh:v1 .

# ===============================
#  Docker run / Daemon

# docker run -d -P --name mytest myssh:v1

# ===============================

# ===============================
# dev container
# ===============================
# https://github.com/Microsoft/vscode-dev-containers/tree/main/containers/kubernetes-helm


# ref : minikube doc
# https://itnext.io/goodbye-docker-desktop-hello-minikube-3649f2a1c469
# https://devops.datenkollektiv.de/minikube-developing-and-testing-locally-with-k8s.html
# https://stackoverflow.com/questions/42564058/how-to-use-local-docker-images-with-minikube
# https://medium.com/rahasak/replace-docker-desktop-with-minikube-and-hyperkit-on-macos-783ce4fb39e3

# network
# https://gist.github.com/elsonrodriguez/add59648d097314d2aac9b3c8931278b

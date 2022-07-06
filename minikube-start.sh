#!/bin/bash

# minikube stop && minikube delete && rm -Rf $HOME/.minikube
# minikube start --cpus 4 --memory 8192 --kubernetes-version=v1.20.0 --vm-driver=virtualbox
# minikube start --kubernetes-version=v1.16.1 --vm-driver=hyperkit --cpus 4 --memory 8192 --show-libmachine-logs --v=10 --alsologtostderr

minikube config set cpus 2
minikube config set memory 4096
# minikube config set driver docker
minikube config set vm-driver hyperkit
minikube config set kubernetes-version v1.21.11
#minikube config set WantVirtualBoxDriverWarning false

minikube start
minikube ip

# link docker
# minikube docker-env
# eval $(minikube -p minikube docker-env)
# eval $(minikube docker-env)
eval $(minikube -p minikube docker-env)

# Minikube MetallB Setting
# https://github.com/kubernetes/minikube/issues/8283
ip_range=$(minikube ip | sed -r 's/(.*)./\1/')
cat ~/.minikube/profiles/minikube/config.json  \
    | jq '.KubernetesConfig.LoadBalancerStartIP="'${ip_range}105'"' \
    | jq '.KubernetesConfig.LoadBalancerEndIP="'${ip_range}120'"'   \
 > ~/.minikube/profiles/minikube/config.json.tmp \
    && mv ~/.minikube/profiles/minikube/config.json.tmp ~/.minikube/profiles/minikube/config.json 

# ===============================
# Addons
minikube addons list

minikube addons enable metallb
minikube addons configure metallb

minikube addons enable metrics-server
minikube addons enable dashboard
minikube addons enable helm-tiller
minikube addons enable ingress
minikube addons enable ingress-dns

# Patch dashboard service
kubectl get svc kubernetes-dashboard -n kubernetes-dashboard -o json \
| jq '.spec.type="LoadBalancer"' \
| jq '.spec.ports[0].port=8443' | k apply -f -

# Open Dashboard directly
DASHBOARD_URL=http://$(kubectl get svc kubernetes-dashboard  -n kubernetes-dashboard --no-headers | awk '{print $4}'):8080
echo "$DASHBOARD_URL"
xdg-open $DASHBOARD_URL

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

# ===============================
# Divers

# minikube event
# minikube logs -f |grep example
# minikube update-check
# minikube ssh
# minikube dashboard
# minikube tunnel
# minikube service xxxx

#  ==============================
# Docker network

# docker network ls
# docker inspect bridge
# docker inspect bridge |jq '.[0].IPAM.Config[0].Gateway'
# docker port xxxx:latest

# ===============================
# Docker build

# docker build -t myssh:v1 .

# ===============================
#  Docker run / Daemon

# docker run -d -P --name mytest myssh:v1

#!/bin/bash
# ===============
# config / settings

# increase virtual memory
# in some scenarios(e.g running elasticsearch) it required more virual memory
# minikube ssh
# sudo sysctl -w vm.max_map_count=262144

# minikube configurations will be stored in the following config file 
# ~/.minikube/machines/minikube/config.json

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
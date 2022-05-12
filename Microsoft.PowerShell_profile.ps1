# Desc Alias for powershell (:p)
# ===== TODO ===========
# cd $env:USERPROFILE\Documents
# md WindowsPowerShell -ErrorAction SilentlyContinue
# cd WindowsPowerShell
# New-Item Microsoft.PowerShell_profile.ps1 -ItemType "file" -ErrorAction SilentlyContinue


function fct_kube_get_pod { kubectl get pod}
Set-Alias -Name kgp -Value fct_kube_get_pod

function fct_kube_get_svc { kubectl get svc}
Set-Alias -Name kgs -Value fct_kube_get_svc

function fct_kube_get_ing { kubectl get ing}
Set-Alias -Name kgi -Value fct_kube_get_ing

function fct_kube { kubectl}
Set-Alias -Name k -Value fct_kube

function fct_kubens {kubectl config set-context --current --namespace=$args }
Set-Alias -Name kns -Value fct_kubens

function kube_pf {kubectl port-forward $args }
Set-Alias -Name kpf -Value kube_pf

function fct_minikube_start {
	minikube config unset vm-driver
	minikube config set virtualbox
	minikube start --kubernetes-version=v1.18.2 --driver=virtualbox --cpus 6 --memory=4096 --no-vtx-check 
	minikube addons enable helm-tiller
	# minikube addons enable dashboard
	# minikube addons enable metrics-server
	# minikube addons enable ingress
	wsl ~/git/ninja/kong/kong_helm_minikube/install_kong.sh
	
}
Set-Alias -Name minikube_start -Value fct_minikube_start

function fct_minikube_stop {.\minikube stop }
Set-Alias -Name minikube_stop -Value fct_minikube_stop

function fct_minikube_delete { 
	minikube delete 
	Remove-Item 'C:\%USERPROFILE%\.minikube'
}
Set-Alias -Name minikube_delete -Value fct_minikube_delete


function fct_kong_proxy { 
	 minikube service -n ingress kong-kong-proxy --url
}
Set-Alias -Name minikube_proxy -Value fct_kong_proxy

function fct_minikube_tunnel { 
	 minikube tunnel --cleanup
}
Set-Alias -Name minikube_tunnel -Value fct_minikube_tunnel

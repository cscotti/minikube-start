# minikube start script

start minikube with additionnal plugins

# Table of contents

<!-- toc -->

- [minikube start script](#minikube-start-script)
- [Table of contents](#table-of-contents)
- [File content](#file-content)
- [Minikube](#minikube)
  - [Misc commands](#misc-commands)
  - [Minikube / Load and remove image (new)](#minikube--load-and-remove-image-new)
  - [Minikube / Load and remove image (old)](#minikube--load-and-remove-image-old)
  - [Minikube / Reference](#minikube--reference)
  - [Minikube / Network](#minikube--network)
- [Docker](#docker)
  - [Commun Commands](#commun-commands)
  - [Docker / Optimize local ressource](#docker--optimize-local-ressource)
  - [Docker / Volume](#docker--volume)
    - [Volume Mount - option 1](#volume-mount---option-1)
    - [Volume Mount - option 2](#volume-mount---option-2)
    - [Volume Mount - option 3](#volume-mount---option-3)
  - [Docker / Network](#docker--network)
  - [Docker / Build](#docker--build)
  - [Docker / Run + Daemon](#docker--run--daemon)
  - [Docker + Vscode Editor -> Dev container](#docker--vscode-editor---dev-container)
- [Annexe](#annexe)
  - [README.md - table content / markdown generator](#readmemd---table-content--markdown-generator)

<!-- tocstop -->

# File content
- `Microsoft.PowerShell_profile.ps1` - powershell shortcuts for kubernetes and minikube (type $profile in powershell and copy paste the content in the file which is prompt -> `C:\Users\<USER>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`)
- `minikube-addon.sh` - activate minikube addons
- `minikube-init.sh` - init minikube environment with default values
- `minikube-purge.sh` - drop minikube instance
- `minikube-start.sh` - start minikube instance
- `minikube-stop.sh` - stop minikube instance

# Minikube 
## Misc commands

```
minikube ip
minikube event
minikube logs -f |grep example
minikube update-check
minikube ssh
minikube dashboard
minikube tunnel
minikube service xxxx
```

## Minikube / Load and remove image (new)
```
minikube image load xxxx:latest
minikube image list
minikube image rm docker.io/library/xxxx:latest
```

## Minikube / Load and remove image (old)
```
minikube cache add xxxx:latest
minikube cache list
minikube cache reload
minikube cache delete xxxx:latest
```
## Minikube / Reference

<https://itnext.io/goodbye-docker-desktop-hello-minikube-3649f2a1c469><br>
<https://devops.datenkollektiv.de/minikube-developing-and-testing-locally-with-k8s.html><br>
<https://stackoverflow.com/questions/42564058/how-to-use-local-docker-images-with-minikube><br>
<https://medium.com/rahasak/replace-docker-desktop-with-minikube-and-hyperkit-on-macos-783ce4fb39e3><br>

## Minikube / Network
<https://gist.github.com/elsonrodriguez/add59648d097314d2aac9b3c8931278b>

# Docker
## Commun Commands

```
# docker run

# build
docker build . -t test-build:latest

# start container
docker stop test-build
docker rm test-build
docker run --name test-build -d test-build:latest bash -c "tail -f /dev/null"

# access to container prompt
docker exec -it test-build /bin/sh

# restart container if stopped
docker restart test-build

# container log
docker logs test-build

# copy file
docker exec test-build cp /source/file.txt /target/file.txt

# push image to docker hub
# https://docs.docker.com/docker-hub/access-tokens/
docker image tag ansible-master:latest <user>/ansible-master:latest
docker image push <user>/ansible-master:latest
docker login -u <user>
docker image push <user>/ansible-master:latest

```

## Docker / Optimize local ressource
The Minikube recent update(v1.24.0) supports to start Minikube VM without starting any Kubernetes in it
used the flag --no-kubernetes
```
minikube config unset kubernetes-version
```

## Docker / Volume
### Volume Mount - option 1

```
# step 1- mount the disk on the laptop to the Hyperkit VM
minikube mount /myvolume:/test

# step 2- run docker
docker run --rm -it -v /test:/inside busybox /bin/sh

ssh to minikube to view the volume /test
minikube ssh

# ex 2
minikube mount $(pwd)/workdir:/workdir
docker run --name test-build -v /workdir:/workdir -d test-build:latest test-build
```
### Volume Mount - option 2
```
stop minikube
minikube stop

# start minikube with volument mount
minikube start --mount --mount-string="/private/var/services/:/private/var/services/"

# volume will be created inside the minikube vm
docker run -d --name redis -p 6379:6379 -v /private/var/services/redis:/data redis:5.0.3
```

### Volume Mount - option 3
<https://github.com/kubernetes/minikube/issues/2481><br>
```
# mac alternative - Volume mount (but can be also run under linux)

ssh-keygen -R $(minikube ip)
scp -ri "$(minikube ssh-key)" "$PWD" docker@$(minikube ip):/tmp

# start container
docker run --name node_build -v /tmp:/source -d ubuntu:22.10 bash -c "tail -f /dev/null"
```

## Docker / Network
```
# configure minikube cluster with new bridge ip
minikube start --docker-opt=bip=172.17.42.1/16

# docker restore bridge ip
minikube start --live-restore

# check docker network
ip a show dev docker0

docker network list
docker network ls
docker inspect bridge
docker inspect bridge |jq '.[0].IPAM.Config[0].Gateway'
docker port xxxx:latest


# When running standard docker compose commands you might need an additional port forward to access your containers
ssh -i ~/.minikube/machines/minikube/id_rsa docker@$(minikube ip) -L '*:19088:0.0.0.0:19088' -N
# Hint: The first port is on the host, the second the post exposed by the container inside minikube.

# add minikube ip to /etc/hosts if want
echo "`minikube ip` docker.local" | sudo tee -a /etc/hosts > /dev/null
```

## Docker / Build
```
docker build -t myssh:v1 .
```

## Docker / Run + Daemon
```
docker run -d -P --name mytest myssh:v1
```

## Docker + Vscode Editor -> Dev container

<https://github.com/Microsoft/vscode-dev-containers/tree/main/containers/kubernetes-helm>


# Annexe
## README.md - table content / markdown generator
<https://stackoverflow.com/questions/18244417/how-do-i-create-some-kind-of-table-of-content-in-github-wiki><br>
<https://github.com/jonschlinkert/markdown-toc>
```
markdown-toc -i README.md
```

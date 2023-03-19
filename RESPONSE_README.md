# Setting up Open5gs and UERansim with 10 UE's (EKS)

### Pre-requisites:

1. Set up your machine with the following CLI tools:
    AWS CLI

    Kubectl

    Helm

2. Set up your local AWS CLI Environment Variables

3. Create an EKS Cluster:

    Recommended settings: https://dish-wireless-network.atlassian.net/wiki/spaces/MSS/pages/427327690/Network+as+an+APP+deployment

Network as App deployment (you have your EKS cluster and node group fired up):

    Update local kubectl config file:

    aws eks --region us-east-1 update-kubeconfig --name response_expirimentation_cluster

do this every time you want to talk to a new cluster

ensure your config file is set up correctly:

 aws eks --region us-east-1 describe-cluster --name response_cluster --query cluster.status

Create openverso namespace and set it to current namespace

kubectl create namespace openverso

kubectl config set-context --current --namespace=openverso

Add OpenVerso to helm

helm repo add openverso https://gradiant.github.io/openverso-charts/

Deploy open5gs, using custom values from DishDevex

helm install open5gs openverso/open5gs --version 2.0.8 --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/master/charts/respons/5gSA-values.yaml

Deploy UERANSIM

helm install ueransim-gnb openverso/ueransim-gnb --version 0.2.2 --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/master/charts/respons/gnb-ues-values.yaml

Ensure that your ten UE’s are set up correctly and you can enable their tunnel interfaces to connect to the internet via the network.

Open an interactive terminal (-ti) for the Deployment (the kubernetes load balancer) of UEs.

kubectl -n openverso exec -ti deployment/ueransim-gnb-ues -- /bin/bash

Inspect the IP addresses of the UEs.

ip addr

Verify that the deployment can communicate with the internet, in particular with google .com (replaceable with dish.com or cats.com)

ping -I uesimtun6 google.com

traceroute -i uesimtun6 google.com

curl --interface uesimtun6 https://www.google.com

Exit the bash session and return to your local machine terminal.

Ensure Mongo DB is updated

kubectl -n openverso exec deployment/open5gs-mongodb -ti -- bash

mongo

use open5gs

db.subscribers.find().pretty()

Ensure all pods are running

kubectl get pods -n openverso

kubectl -n openverso logs deployment/ueransim-gnb
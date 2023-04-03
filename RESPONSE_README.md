# Setting up Open5gs and UERansim with 10 UE's (EKS)

### Pre-requisites:

1. Set up your machine with the following CLI tools:
    - AWS CLI

    - Kubectl

    - Helm


2. Set up your local AWS CLI Environment Variables

3. Create an EKS Cluster:

    Recommended settings: https://dish-wireless-network.atlassian.net/wiki/spaces/MSS/pages/427327690/Network+as+an+APP+deployment

### Network as App deployment (you have your EKS cluster and node group fired up):


1. Update local kubectl config file:

    ```console
    aws eks --region us-east-1 update-kubeconfig --name response_expirimentation_cluster
    ```

    (do this every time you want to talk to a new cluster)

2. ensure your config file is set up correctly:

    ```console
    aws eks --region us-east-1 describe-cluster --name response_cluster --query cluster.status
    ```

3. Create openverso namespace and set it to current namespace

    ```console
    kubectl create namespace openverso
    ```

    ```console
    kubectl config set-context --current --namespace=openverso
    ```

4. Add OpenVerso to helm

    ```console
    helm repo add openverso https://gradiant.github.io/openverso-charts/
    ```

5. Deploy open5gs, using custom values from DishDevex

    ```console
    helm install open5gs openverso/open5gs --version 2.0.8 --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/master/charts/respons/5gSA_ues_values.yaml
    ```

6. Deploy UERANSIM, using custom values from DishDevex

    ```console
    helm install ueransim-gnb openverso/ueransim-gnb --version 0.2.2 --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/master/charts/respons/gnb_ues_values.yaml
    ```

### Ensure that your ten UE’s are set up correctly and you can enable their tunnel interfaces to connect to the internet via the network.

1. Open an interactive terminal (-ti) for the Deployment (the kubernetes load balancer) of UEs.

    ```console
    kubectl -n openverso exec -ti deployment/ueransim-gnb-ues -- /bin/bash
    ```
2. Inspect the IP addresses of the UEs.

    ```console
    ip addr
    ```
3. Verify that the deployment can communicate with the internet, in particular with google.com (replaceable with dish.com or cats.com)

    ```console
    ping -I uesimtun6 google.com
    ```
    ```console
    traceroute -i uesimtun6 google.com
    ```
    ```console
    curl --interface uesimtun6 https://www.google.com
    ```
4. Exit the bash session and return to your local machine terminal.

5. Ensure Mongo DB is updated

    ```console
    kubectl -n openverso exec deployment/open5gs-mongodb -ti -- bash
    ```
    ```console
    mongo
    ```
    ```console
    use open5gs
    ```
    ```console
    db.subscribers.find().pretty()
    ```
6. Ensure all pods are running

    ```console
    kubectl get pods -n openverso

    kubectl -n openverso logs deployment/ueransim-gnb
    ```

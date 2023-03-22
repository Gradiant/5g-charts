# Welcome to Respons's UE Test Kit

This test kit is meant to enable large scale UE simulation to put load on the open5gs and UERANSIM infrastructure.   

# Pre-requisites:
(1) Set up your machine with the following CLI tools:

    AWS CLI

    Kubectl

    Helm

(2) Set up your local AWS CLI Environment Variables

(3) Update local kubectl config file:

```console
aws eks --region us-east-1 update-kubeconfig --name response_expirimentation_cluster
```

(4) Add openverso to your helm repo
```console
helm repo add openverso https://gradiant.github.io/openverso-charts/
```

# How to create tests

### Update the test_case_values.json
Here you can add more tests, or update previous test case parameters

### Using the script generation files:

(1) To create scripts that populate open5gs mongodb:
    Run the ue_populate_creation file 
```console
python ue_populate_creation.py
```
    
(2) To create scripts that emulate ue ping requests with a fixed upper limit:
```console
python ping_test_creation.py
```
    
(3) To create scripts that emulate ue curl requests continously:
```console
python ping_test_creation.py
```

# How to generate load on open5gs and UERANSIM with a large ue population

### Set up many ue environment

(1)install open5gs (2.5 mins)
```console
helm install open5gs openverso/open5gs --version 2.0.9 --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/vinny/10kUE/charts/respons/5gSA_no_ues_values.yaml
```
(2) Populate (5 mins)

Open the terminal for the populate pod

```console
kubectl -n openverso exec -ti deployment/open5gs-populate -- /bin/bash
```

Inside the terminal for the populate pod copy paste contents of:  openverso-charts/respons_ue_test_kit/simulation_scripts/ue_populate.sh

(3) Install GNB (1 minute)
```console
helm install ueransim-gnb openverso/ueransim-gnb --version 0.2.5 --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/vinny/10kUE/charts/respons/gnb_no_ues_values.yaml
```
(4) install first batch of 450 ues	(1 minute)
```console
helm install -n openverso ueransim-ues-first-batch openverso/ueransim-ues --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/vinny/10kUE/charts/respons/0_450_ue_values.yaml
```

optional: (this can cause many bugs in the app, slowly add batches of UE’s and wait for the previous batch to fully connect all of the ue tunnels )

(5) install second batch of 450 ues (3 mins)
```console
helm install -n openverso ueransim-ues-second-batch openverso/ueransim-ues --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/vinny/10kUE/charts/respons/450_900_ue_values.yaml
```

(6) install third batch of 450 ues (15 mins)
```console
helm install -n openverso ueransim-ues-third-batch openverso/ueransim-ues --values https://raw.githubusercontent.com/DISHDevEx/openverso-charts/vinny/10kUE/charts/respons/900_1350_ue_values.yaml
```

### Enter the Terminal for your UE pods
```console
kubectl -n openverso exec -ti deployment/ueransim-ues-first-batch -- /bin/bash

kubectl -n openverso exec -ti deployment/ueransim-ues-second-batch -- /bin/bash

kubectl -n openverso exec -ti deployment/ueransim-ues-third-batch -- /bin/bash
```

### Ensure all tunnels are connected
```console
ip addr
```
here you should see every ue denoted with a uesimtun{number}

### Run curl/ping tests
To run curl or ping tests via UEs, have the terminals for the UE pods open from the previous step. 

paste the contents of either of the following files (inside the terminal for an UE pod):

```console
respons_ue_test_kit/simulation_scripts/curl.sh

respons_ue_test_kit/simulation_scripts/ping.sh
```


### Trouble shooting section
Often times with such a large amount of UE's deployed in the app, you may face common issues such as segementation faults. 

Try restarting certain applications to get them back online and connected 

```console
kubectl rollout restart deployment ueransim-gnb -n openverso

kubectl rollout restart deployment ueransim-ues-first-batch  -n openverso

kubectl rollout restart deployment ueransim-ues-second-batch  -n openverso

kubectl rollout restart deployment ueransim-ues-third-batch  -n openverso
```

### Uninstall deployment
```console
helm uninstall open5gs
helm uninstall ueransim-gnb
helm uninstall ueransim-ues-first-batch
helm uninstall ueransim-ues-second-batch
helm uninstall ueransim-ues-third-batch
```
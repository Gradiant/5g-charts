

Deploy free5gc chart from source (from the root of this repo):

```
helm install free5gc charts/free5gc
```

Wait until all pods are ready:

```
kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
free5gc-amf-674547954c-tt6z4          1/1     Running   0          95s
free5gc-ausf-7ddfddf5fb-wbq2v         1/1     Running   0          95s
free5gc-mongodb-645455766c-6fbr4      1/1     Running   0          95s
free5gc-nrf-775c5c4cb-82dh5           1/1     Running   0          95s
free5gc-nssf-7f6cb55fff-2k8th         1/1     Running   0          95s
free5gc-pcf-6fd5548865-22wvr          1/1     Running   0          95s
free5gc-smf-c96686dd9-x8bbd           1/1     Running   0          95s
free5gc-udm-6c6d5c5c77-t9pjg          1/1     Running   0          95s
free5gc-udr-65cbcd54c4-fdmm2          1/1     Running   0          95s
free5gc-upf-8679cf68dc-wfw94          1/1     Running   0          94s
free5gc-webconsole-7957d89c79-qvzkd   1/1     Running   0          95s

```

Register subscribers:

```
kubectl port-forward svc/free5gc-webconsole 5000:5000 &
./docs/free5gc-ueransim/register_free5gc_subscribers.sh
fg
CTRL-C
```

Deploy ueransim-gnb with 1 ue:

``` 
helm install ueransim-gnb charts/ueransim-gnb --set amf.hostname=free5gc-amf-sctp --set ues.enabled=true
```


Output info. You can use [stern](https://github.com/wercker/stern/releases/tag/1.11.0) to get multiple pod logs:

```
stern "free5gc-amf|free5gc-smf|free5gc-upf"
```

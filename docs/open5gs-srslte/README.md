# open5gs and srsLTE 

5G end to end communication demo with open5gs and srsLTE.

# Deployment EPC and register subscribers

deploy the EPC core (open5gs) with:

```
helm3 install --name epc --namespace test --values epc_values.yaml ../charts/open5gs/
```

Register subscriber in epc with `/register_subscriber.sh`.


# Deployment RAN

Deploy with

```
helm3 install --name lte --namespace test ../charts/srs-lte/ --values lte_values.yaml
```

Check if the tunnel interface is created.  

```
kubectl -n test exec lte-srs-lte-0 -c ue -- ip address list
```
There should be a new interface named `tun_srsue`. Now change the default route: 

```
kubectl -n test exec lte-srs-lte-0 -c ue  --  ip route replace default dev tun_srsue
```
Check it works: 
```
traceroute google.com
```
The first hop should be  `10.45.0.1`.
Undeploy with:

```
helm3 delete --purge lte 
```
# charts

Helm charts for 5G Technologies on Kubernetes.

## Install chart from helm repository

charts in `charts/`` folder are packaged and available at Gradiant's openverso helm repo:  

[https://gradiant.github.io/openverso-charts/](https://gradiant.github.io/openverso-charts/)

You can add the helm repo to your Helm CLI:

```bash
helm repo add openverso https://gradiant.github.io/openverso-charts/
```

Then you have a collection of charts available to install. For example, to install open5gs-epc:

```bash
helm install openverso/open5gs-epc
```

## Install chart from release

install using the URL of the release. For example, to install open5gs-epc v0.1.0 chart:

```bash
helm install https://github.com/Gradiant/openverso-charts/releases/download/open5gs-epc-0.1.0/open5gs-epc-0.1.0.tgz
```

## Development

- clone repo
- adjust given chart
- bump chart version if required
- run tests
- create pull request with issue id, attach test results if possible

### Requirements

- linting requires docker
- running install or lint-and-install requires access to the kubernetes cluster - can be minikube, kubernetes-in-docker, or real cluster
- `tee` console tool to output to the console and file in the same time

## Linting and testing full deployment
s
We use helm [chart-testing](https://github.com/helm/chart-testing) running a docker image.

An example to test specific chart, lint and install, send console logs also to the log file `reports/*.log`:

```bash
scripts/lint-install.sh open5gs-epc | tee reports/open5gs-epc.log
```

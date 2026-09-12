# Istio VirtualService Demo

This repository has **Kubernetes YAML only**. The application images are already on Docker Hub. You do not need to build Docker images.

**Images**

- [aaqibshaikh199/istio-learning:VIRTUAL-SERVICE-01](https://hub.docker.com/r/aaqibshaikh199/istio-learning) — server one
- [aaqibshaikh199/istio-learning:VIRTUAL-SERVICE-02](https://hub.docker.com/r/aaqibshaikh199/istio-learning) — server two

**What each server returns**

| URL | Server one | Server two |
| --- | --- | --- |
| `/` | `THIS IS FROM SERVER ONE` | `THIS IS FROM SERVER TWO` |
| `/hello` | `HELLO from server ONE` | `HELLO from server TWO` |

`/hello` is part of the Docker image (an Nginx file). It is not an Istio route.

---

## Files in this repo

```text
namespace.yaml
deployment.yaml
service.yaml
virtualservice-percentage.yaml
```

| File | Purpose |
| --- | --- |
| `namespace.yaml` | Creates `vs-demo` and enables Istio sidecar injection |
| `deployment.yaml` | Runs the two servers from Docker Hub |
| `service.yaml` | Names them `server-one` and `server-two` |
| `virtualservice-percentage.yaml` | Optional: send 80% of traffic to server one, 20% to server two |

---

## Prerequisites

- A Kubernetes cluster (minikube, kind, or Docker Desktop)
- `kubectl`
- Istio installed if you want the VirtualService exercise

```bash
kubectl get svc -n istio-system istio-ingressgateway
```

---

## Deploy

```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Wait until both pods are `2/2 Running`:

```bash
kubectl get pods -n vs-demo
```

Example:

```text
NAME                          READY   STATUS    RESTARTS   AGE
server-one-xxxxxxxxx-xxxxx    2/2     Running   0          20s
server-two-xxxxxxxxx-xxxxx    2/2     Running   0          20s
```

`2/2` means Nginx + the Istio sidecar.

---

## Open a shell in a pod

Kubernetes does not use `ssh`. Use `kubectl exec`.

```bash
kubectl get pods -n vs-demo
```

Then:

```bash
kubectl exec -it -n vs-demo <pod-name> -c nginx -- /bin/bash
```

Or skip the pod name:

```bash
kubectl exec -it -n vs-demo deploy/server-one -c nginx -- /bin/bash
```

Use `-c nginx` so you enter the app container, not the Istio sidecar.

You should see:

```text
root@server-one-xxxxx:/#
```

Type `exit` to leave.

---

## Test from inside the pod

```bash
curl http://server-one
curl http://server-two

curl http://server-one/hello
curl http://server-two/hello
```

Expected:

```text
THIS IS FROM SERVER ONE
THIS IS FROM SERVER TWO
HELLO from server ONE
HELLO from server TWO
```

Other useful commands inside the pod:

```bash
ping -c 3 server-two
nslookup server-two
ip addr
```

---

## Optional: Istio 80/20 routing

```bash
kubectl apply -f virtualservice-percentage.yaml
```

This VirtualService needs an Istio Gateway named `demo-gateway`. After that is in place:

```bash
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
```

In another terminal:

```bash
for i in {1..20}; do curl -s http://localhost:8080; echo; done
```

You should see a mix of server one and server two (about 80% / 20%).

---

## Clean up

```bash
kubectl delete namespace vs-demo
```

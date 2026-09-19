# Istio Virtual Service Learning — Curl Commands

Run from inside a pod: `kubectl exec -it -n one deploy/server-one -- bash`

## Deployment One

```bash
curl server-one.one.svc.cluster.local/
curl server-one.one.svc.cluster.local/hello
curl server-one.one.svc.cluster.local/ip
curl server-one.one.svc.cluster.local/host
curl server-one.one.svc.cluster.local/headers
curl server-one.one.svc.cluster.local/whoami
curl server-one.one.svc.cluster.local/env
curl server-one.one.svc.cluster.local/healthz
curl -i server-one.one.svc.cluster.local/status/503
curl server-one.one.svc.cluster.local/delay/3
```

## Deployment Two

```bash
curl server-two.two.svc.cluster.local/
curl server-two.two.svc.cluster.local/hello
curl server-two.two.svc.cluster.local/ip
curl server-two.two.svc.cluster.local/host
curl server-two.two.svc.cluster.local/headers
curl server-two.two.svc.cluster.local/whoami
curl server-two.two.svc.cluster.local/env
curl server-two.two.svc.cluster.local/healthz
curl -i server-two.two.svc.cluster.local/status/503
curl server-two.two.svc.cluster.local/delay/3
```

## Cross-namespace check

```bash
kubectl exec -n one deploy/server-one -- curl -s server-two.two.svc.cluster.local/whoami
kubectl exec -n two deploy/server-two -- curl -s server-one.one.svc.cluster.local/whoami
```

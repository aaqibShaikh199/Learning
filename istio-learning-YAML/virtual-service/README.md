# Istio VirtualService URI Rewrite Test

Created **3 deployments** to test Istio `VirtualService` URI rewriting.

* **Deployment 1:** Istio enabled + `VirtualService` applied.
* **Deployment 2:** Istio sidecar enabled.
* **Deployment 3:** Istio sidecar disabled.

### Test 1 — Deployment 2

Request:

```bash
curl http://service-one.one.svc.cluster.local/hello
```

Result:

```text
/hello → /ip
```

✅ Rewrite worked because the request passed through the Istio sidecar.

### Test 2 — Deployment 3

Same request:

```bash
curl http://service-one.one.svc.cluster.local/hello
```

Result:

```text
/hello → /hello
```

❌ Rewrite did not happen because Deployment 3 does not have an Istio sidecar.

### Conclusion

**Istio sidecar is required on the source workload for the `VirtualService` routing/rewrite rule to be applied.**

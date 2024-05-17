# k8s-mimir-reloader

Conatins a simple implementation to the mimirtool to run in K8s and load rules based on configmaps

The solution is based on:

1. npm onchange package
2. kiwigrid/k8s-sidecar


## Manage rules using CM

To support the create/delete, File name should be by <namespace_name>.<group_name>.yaml (see [example](./examples/rule_cm.yaml))

Each group should be in a different file
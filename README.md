# Kubernetes GitOps - ArgoCD Self-Managed

This repository contains an example about how to use an ArgoCD Self-Managed instance.

The approach can be used for DR in production as it solves the Chicken and Egg Problem. To deploy it the first time:

1. Create a Cluster. This repo is prepared for Kind Cluster. To enable the Ingress use:

```bash
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

Reference: [Kind](https://kind.sigs.k8s.io/docs/user/ingress/)

2. Run `kubectl kustomize https://github.com/imjoseangel/k8s-gitops/argocd?ref=HEAD | kubectl apply -f -`
3. Modify your file `/etc/hosts`:

```text
127.0.0.1    localhost argocd.imjoseangel.eu.org argo-workflow.imjoseangel.eu.org
```

4. Open `https://argocd.imjoseangel.eu.org` and enter the username `admin` and the password
5. Confirm that all the components are in sync

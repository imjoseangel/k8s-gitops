# 🚀 ArgoCD Self-Managed Example

This repository demonstrates how to deploy a self-managed instance of **ArgoCD**. This approach can be used for disaster recovery (DR) in production environments by solving the Chicken and Egg Problem 🐔🥚.

---

## 🎯 Key Features

- **Self-Managed ArgoCD**: Run your own ArgoCD instance for more control.
- **Disaster Recovery**: Use this setup for production-level DR scenarios.
- **Kind Cluster**: Easily deploy on a Kind Cluster.
- **Automatic SSL/TLS Certificates**: Seamlessly manage certificates with cert-manager.
- **Cloudflare DNS Integration**: Leverage Cloudflare for DNS management and enhanced security.

---

## 🛠️ Prerequisites

Before you begin, ensure you have the following tools installed:

- [Kind](https://kind.sigs.k8s.io/) - A tool for running local Kubernetes clusters using Docker.
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - Command line tool for interacting with your Kubernetes cluster.

---

## 🚀 Deployment Guide

Follow these steps to deploy your ArgoCD instance.

### 1️⃣ Create a Kubernetes Cluster

First, you'll need to create a Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/). The configuration below sets up a cluster with Ingress enabled:

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

For more details on Kind, check out the [Kind Documentation](https://kind.sigs.k8s.io/docs/user/ingress/)

### 2️⃣ Deploy ArgoCD

Once your cluster is up and running, deploy ArgoCD using the following command:

```bash
kubectl kustomize https://github.com/imjoseangel/k8s-gitops/argocd?ref=HEAD | kubectl apply -f -
```

### 3️⃣ Configure /etc/hosts

To access the ArgoCD UI locally, you’ll need to add the following entries to your `/etc/hosts` file:

```bash
127.0.0.1    localhost argocd.imjoseangel.eu.org argo-workflow.imjoseangel.eu.org
```

### 4️⃣ Access the ArgoCD UI

Open your browser and navigate to:

👉 [https://argocd.imjoseangel.eu.org](https://argocd.imjoseangel.eu.org)

Login with the default credentials:

- **Username:** `admin`
- **Password:** (generated on first-time setup)

> **Note:** You might want to change the password immediately after logging in.

### 5️⃣ Verify Deployment

Once logged in, confirm that all the components are in sync:

---

## 📚 Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [Kind Documentation](https://kind.sigs.k8s.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

---

## 🛡️ License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues](https://github.com/imjoseangel/k8s-gitops/issues) page.

---

## 🙏 Acknowledgments

Special thanks to the contributors of this project for their continuous effort.

Enjoy using ArgoCD! If you encounter any issues, feel free to open an issue on this repository. 😊

# 🚀 ArgoCD Self-Managed Example

This repository demonstrates how to deploy a self-managed instance of **ArgoCD**. This approach can be used for disaster recovery (DR) in production environments by solving the Chicken and Egg Problem 🐔🥚.

---

## 🎯 Key Features

- **Self-Managed ArgoCD**: Run your own ArgoCD instance for more control.
- **Disaster Recovery**: Use this setup for production-level DR scenarios.
- **Kind Cluster**: Easily deploy on a Kind Cluster.
- **Automatic SSL/TLS Certificates**: Seamlessly manage certificates with cert-manager.
- **Cloudflare DNS Integration**: Leverage Cloudflare for DNS management and enhanced security.
- **Argo Workflows**: Manage complex workflows and pipeline orchestration.
- **Okta SSO Integration**: Secure access to ArgoCD using Okta Single Sign-On (SSO).

---

## 🛠️ Prerequisites

Before you begin, ensure you have the following tools installed:

- [Kind](https://kind.sigs.k8s.io/) - A tool for running local Kubernetes clusters using Docker.
- [kubectl](https://kubernetes.io/docs/tasks/tools/) - Command line tool for interacting with your Kubernetes cluster.
- [Make](https://www.gnu.org/software/make/) - A tool to simplify the build and deployment process.

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

### 2️⃣ Configure Cloudflare API Token

To use Cloudflare, you may use **API Tokens**.

Tokens can be created at User **Profile > API Tokens > API Tokens**. The following settings are recommended:

- Permissions:
  - Zone - DNS - Edit
  - Zone - Zone - Read

- Zone Resources:
  - Include - All Zones

First automate a Kubernetes secret containing the new API token:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token-secret
  namespace: cert-manager
type: Opaque
stringData:
  api-token: <API Token>
```

More info at [Cloudflare Documentation](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/)

### 3️⃣ Configure Okta SSO for ArgoCD

To secure access to ArgoCD with Okta SSO, follow these steps:

**1. Create an Okta developer account:**

Access to [Okta Developer](https://developer.okta.com/signup/) and follow the instructions.

**2. Create an Application in Okta:**

- Sign in to your Okta admin dashboard.
- Navigate to **Applications > Applications** and click **Create App Integration.**
- Set up the application following the [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/okta/)

Implement Okta SSO with the following secret:

```yaml
---
apiVersion: v1
data:
  sso-url: <base64 url>
  sso-cer: <base64 of base64 cer>
kind: Secret
metadata:
  labels:
    app.kubernetes.io/component: server
    app.kubernetes.io/instance: argocd
    app.kubernetes.io/name: okta-secret
    app.kubernetes.io/part-of: argocd
  name: okta-secret
  namespace: argocd
type: Opaque
```

### 4️⃣ Deploy ArgoCD

Once your cluster is up and running, deploy ArgoCD using the following command:

```bash
kubectl kustomize https://github.com/imjoseangel/k8s-gitops/argocd?ref=HEAD | kubectl apply -f -
```

### 5️⃣  Configure /etc/hosts

To access the ArgoCD UI locally, you’ll need to add the following entries to your `/etc/hosts` file:

```bash
127.0.0.1    localhost argocd.imjoseangel.eu.org argo-workflow.imjoseangel.eu.org prometheus.imjoseangel.eu.org
```

### 6️⃣ Access the ArgoCD UI

Open your browser and navigate to:

👉 [https://argocd.imjoseangel.eu.org](https://argocd.imjoseangel.eu.org)

Login with the default credentials:

- **Username:** `admin`
- **Password:** `password`

> **Note:** You might want to change the password immediately after logging in.

If Okta is prepared, use the **Login via Okta** button.

### 7️⃣ Verify Deployment

Once logged in, confirm that all the components are in sync.

### 8️⃣ Access the Argo Workflows UI (Without SSO)

In this demo, get your token running (SSO with ArgoCD DEX [Recommended](https://argo-workflows.readthedocs.io/en/latest/argo-server-sso-argocd/)):

```bash
echo "Bearer $(kubectl get secrets -n argo-workflows argo-reader-user.service-account-token -o jsonpath='{.data.token}' | base64 --decode)"
```

Open your browser and navigate to:

👉 [https://argo-workflows.imjoseangel.eu.org](https://argo-workflows.imjoseangel.eu.org)

Enter your token

---

## 📚 Additional Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [Kind Documentation](https://kind.sigs.k8s.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [`cert-manager` Documentation](https://cert-manager.io/docs/)
- [Cloudflare API Documentation](https://developers.cloudflare.com/api/)
- [Okta Documentation](https://developer.okta.com/docs/guides/)

---

## 📦 Makefile

To simplify your workflow, a `Makefile` is provided to automate common tasks.

### Available Commands

- **Deploy ArgoCD:** Deploys ArgoCD to the cluster.

```bash
make deploy
```

- **Delete ArgoCD:** Deletes ArgoCD from the cluster.

```bash
make delete
```

- **Create K8S Cluster:**  Creates Kind Kubernetes Cluster.

```bash
make cluster
```

- **Destroy K8S Cluster:**  Destroys Kind Kubernetes Cluster.

```bash
make destroy
```

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

---

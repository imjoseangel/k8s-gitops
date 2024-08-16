.DEFAULT_GOAL:=help

PATH     := $(PATH):$(PWD)/bin
OS       := $(shell uname -s | tr '[:upper:]' '[:lower:]' | sed 's/darwin/apple-darwin/' | sed 's/linux/linux-gnu/')
ARCH     := $(shell uname -m)
DATE     := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

.POSIX:

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: deploy-argocd
deploy-argocd: ## Deploys ArgoCD Application and Resources
	$(info $(DATE) - deploying argocd)
	@kustomize build argocd | kubectl apply -f -
	@sleep 10
	@kustomize build argocd-resources | kubectl apply -f -

.PHONY: delete-argocd
delete-argocd: ## Deletes ArgoCD Application and Resources
	$(info $(DATE) - deleting argocd)
	@kustomize build argocd-resources | kubectl delete -f -
	@kustomize build argocd | kubectl delete -f -

.PHONY: clean
clean: ## Cleanup the project folders with git clean
	$(info $(DATE) - cleaning up)
	@git clean -dfx

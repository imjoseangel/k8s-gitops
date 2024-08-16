.DEFAULT_GOAL:=help

PATH     := $(PATH):$(PWD)/bin
OS       := $(shell uname -s | tr '[:upper:]' '[:lower:]' | sed 's/darwin/apple-darwin/' | sed 's/linux/linux-gnu/')
ARCH     := $(shell uname -m)
DATE     := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

.POSIX:

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: apply
apply: ## Deploys ArgoCD Application and Resources
	$(info $(DATE) - deploying argocd)
	@kustomize build argocd | kubectl apply -f -
	$(info $(DATE) - sleeping 10 seconds)
	@sleep 10
	$(info $(DATE) - deploying resources)
	@kustomize build argocd-resources | kubectl apply -f -

.PHONY: delete
delete: ## Deletes ArgoCD Application and Resources
	$(info $(DATE) - deleting resources)
	@kustomize build argocd-resources | kubectl delete -f -
	$(info $(DATE) - deleting argocd)
	@kustomize build argocd | kubectl delete -f -

.PHONY: clean
clean: ## Cleanup the project folders with git clean
	$(info $(DATE) - cleaning up)
	@git clean -dfx

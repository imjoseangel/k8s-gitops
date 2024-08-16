#****************************************************************************
#
#    GNU/       __  __       _         __ _ _
#      /gmake  |  \/  | __ _| | _____ / _(_) | ___
#     /        | |\/| |/ _` | |/ / _ \ |_| | |/ _ \
#    /MIT      | |  | | (_| |   <  __/  _| | |  __/
#              |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#
#                           ARGOCD
#
#   FILENAME: Makefile  AUTHOR: "Jose Angel Munoz"
#   COPYRIGHT: "2024 Jose Angel Munoz" LICENSE: "MIT"
#   PURPOSE: ArgoCD Deployment
#
#                This file probably requires GNU gmake.
#****************************************************************************

.DEFAULT_GOAL:=help

PATH     := $(PATH):$(PWD)/bin
OS       := $(shell uname -s | tr '[:upper:]' '[:lower:]' | sed 's/darwin/apple-darwin/' | sed 's/linux/linux-gnu/')
ARCH     := $(shell uname -m)
DATE     := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

.POSIX:

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: deploy
deploy: ## Deploys ArgoCD Application and Resources
	$(info $(DATE) - deploying argocd)
	@kustomize build argocd | kubectl apply -f -
	@sleep 10
	@kustomize build argocd-resources | kubectl apply -f -

.PHONY: delete
delete: ## Deletes ArgoCD Application and Resources
	$(info $(DATE) - deleting argocd)
	@kustomize build argocd-resources | kubectl delete -f -
	@kustomize build argocd | kubectl delete -f -

.PHONY: clean
clean: ## Cleanup the project folders with git clean
	$(info $(DATE) - cleaning up)
	@git clean -dfx

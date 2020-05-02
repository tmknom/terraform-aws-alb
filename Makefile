# https://github.com/tmknom/template-terraform-module
TERRAFORM_VERSION := 0.12.24
-include .Makefile.terraform

.Makefile.terraform:
	curl -sSL https://raw.githubusercontent.com/tmknom/template-terraform-module/0.2.6/Makefile.terraform -o .Makefile.terraform

MINIMAL_DIR := ./examples/minimal
COMPLETE_DIR := ./examples/complete
ONLY_HTTP_DIR := ./examples/only_http
ONLY_HTTPS_DIR := ./examples/only_https

# If TF_VAR_domain_name set in the environment variables, that value will use in the examples.
DOMAIN_NAME := $(shell echo $${TF_VAR_domain_name})

plan-minimal: ## Run terraform plan examples/minimal
	$(call terraform,${MINIMAL_DIR},init,)
	$(call terraform,${MINIMAL_DIR},plan,-var domain_name=${DOMAIN_NAME})

apply-minimal: ## Run terraform apply examples/minimal
	$(call terraform,${MINIMAL_DIR},apply,-var domain_name=${DOMAIN_NAME})

destroy-minimal: ## Run terraform destroy examples/minimal
	$(call terraform,${MINIMAL_DIR},destroy,-var domain_name=${DOMAIN_NAME})

plan-complete: ## Run terraform plan examples/complete
	$(call terraform,${COMPLETE_DIR},init,)
	$(call terraform,${COMPLETE_DIR},plan,-var domain_name=${DOMAIN_NAME})

apply-complete: ## Run terraform apply examples/complete
	$(call terraform,${COMPLETE_DIR},apply,-var domain_name=${DOMAIN_NAME})

destroy-complete: ## Run terraform destroy examples/complete
	$(call terraform,${COMPLETE_DIR},destroy,-var domain_name=${DOMAIN_NAME})

plan-only-http: ## Run terraform plan examples/only_http
	$(call terraform,${ONLY_HTTP_DIR},init,)
	$(call terraform,${ONLY_HTTP_DIR},plan,)

apply-only-http: ## Run terraform apply examples/only_http
	$(call terraform,${ONLY_HTTP_DIR},apply,)

destroy-only-http: ## Run terraform destroy examples/only_http
	$(call terraform,${ONLY_HTTP_DIR},destroy,)

plan-only-https: ## Run terraform plan examples/only_https
	$(call terraform,${ONLY_HTTPS_DIR},init,)
	$(call terraform,${ONLY_HTTPS_DIR},plan,-var domain_name=${DOMAIN_NAME})

apply-only-https: ## Run terraform apply examples/only_https
	$(call terraform,${ONLY_HTTPS_DIR},apply,-var domain_name=${DOMAIN_NAME})

destroy-only-https: ## Run terraform destroy examples/only_https
	$(call terraform,${ONLY_HTTPS_DIR},destroy,-var domain_name=${DOMAIN_NAME})

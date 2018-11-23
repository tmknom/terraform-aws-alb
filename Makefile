# https://github.com/tmknom/template-terraform-module
TERRAFORM_VERSION := 0.11.10
-include .Makefile.terraform

.Makefile.terraform:
	curl -sSL https://raw.githubusercontent.com/tmknom/template-terraform-module/master/Makefile.terraform -o .Makefile.terraform

MINIMAL_DIR := ./examples/minimal
COMPLETE_DIR := ./examples/complete
ONLY_HTTP_DIR := ./examples/only_http
ONLY_HTTPS_DIR := ./examples/only_https

# If TF_VAR_domain_name set in the environment variables, that value will use in the examples.
DOMAIN_NAME := $(shell echo $${TF_VAR_domain_name})

terraform-plan-minimal: ## Run terraform plan examples/minimal
	$(call terraform,${MINIMAL_DIR},init)
	$(call terraform,${MINIMAL_DIR},plan,-var domain_name=${DOMAIN_NAME}) | tee -a /dev/stderr | docker run --rm -i tmknom/terraform-landscape

terraform-apply-minimal: ## Run terraform apply examples/minimal
	$(call terraform,${MINIMAL_DIR},apply,-var domain_name=${DOMAIN_NAME})

terraform-destroy-minimal: ## Run terraform destroy examples/minimal
	$(call terraform,${MINIMAL_DIR},destroy,-var domain_name=${DOMAIN_NAME})

terraform-plan-complete: ## Run terraform plan examples/complete
	$(call terraform,${COMPLETE_DIR},init)
	$(call terraform,${COMPLETE_DIR},plan,-var domain_name=${DOMAIN_NAME}) | tee -a /dev/stderr | docker run --rm -i tmknom/terraform-landscape

terraform-apply-complete: ## Run terraform apply examples/complete
	$(call terraform,${COMPLETE_DIR},apply,-var domain_name=${DOMAIN_NAME})

terraform-destroy-complete: ## Run terraform destroy examples/complete
	$(call terraform,${COMPLETE_DIR},destroy,-var domain_name=${DOMAIN_NAME})

terraform-plan-only-http: ## Run terraform plan examples/only_http
	$(call terraform,${ONLY_HTTP_DIR},init)
	$(call terraform,${ONLY_HTTP_DIR},plan,-var domain_name=${DOMAIN_NAME}) | tee -a /dev/stderr | docker run --rm -i tmknom/terraform-landscape

terraform-apply-only-http: ## Run terraform apply examples/only_http
	$(call terraform,${ONLY_HTTP_DIR},apply,-var domain_name=${DOMAIN_NAME})

terraform-destroy-only-http: ## Run terraform destroy examples/only_http
	$(call terraform,${ONLY_HTTP_DIR},destroy,-var domain_name=${DOMAIN_NAME})

terraform-plan-only-https: ## Run terraform plan examples/only_https
	$(call terraform,${ONLY_HTTPS_DIR},init)
	$(call terraform,${ONLY_HTTPS_DIR},plan,-var domain_name=${DOMAIN_NAME}) | tee -a /dev/stderr | docker run --rm -i tmknom/terraform-landscape

terraform-apply-only-https: ## Run terraform apply examples/only_https
	$(call terraform,${ONLY_HTTPS_DIR},apply,-var domain_name=${DOMAIN_NAME})

terraform-destroy-only-https: ## Run terraform destroy examples/only_https
	$(call terraform,${ONLY_HTTPS_DIR},destroy,-var domain_name=${DOMAIN_NAME})

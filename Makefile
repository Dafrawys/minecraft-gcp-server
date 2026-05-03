init:
	cd terraform && terraform init

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply -auto-approve

destroy:
	cd terraform && terraform destroy -auto-approve

deploy-bash:
	chmod +x deploy.sh && ./deploy.sh

help:
	@echo "Available commands:"
	@echo "make init       - Initialize Terraform"
	@echo "make plan       - Show execution plan"
	@echo "make apply      - Apply infrastructure"
	@echo "make destroy    - Destroy infrastructure"
	@echo "make deploy-bash - Run Bash deployment"
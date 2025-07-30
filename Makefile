# Makefile for AWS Hybrid Connectivity Module

.PHONY: help init plan apply destroy validate fmt clean test

# Default target
help:
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan Terraform changes"
	@echo "  apply     - Apply Terraform changes"
	@echo "  destroy   - Destroy Terraform resources"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  fmt       - Format Terraform code"
	@echo "  clean     - Clean up temporary files"
	@echo "  test      - Run tests"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Plan Terraform changes
plan:
	@echo "Planning Terraform changes..."
	terraform plan

# Apply Terraform changes
apply:
	@echo "Applying Terraform changes..."
	terraform apply

# Destroy Terraform resources
destroy:
	@echo "Destroying Terraform resources..."
	terraform destroy

# Validate Terraform configuration
validate:
	@echo "Validating Terraform configuration..."
	terraform validate

# Format Terraform code
fmt:
	@echo "Formatting Terraform code..."
	terraform fmt -recursive

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -f *.tfstate
	rm -f *.tfstate.backup

# Run tests (placeholder for future test implementation)
test:
	@echo "Running tests..."
	@echo "Tests not yet implemented"

# Example-specific targets
example-basic-init:
	@echo "Initializing basic example..."
	cd examples/basic && terraform init

example-basic-plan:
	@echo "Planning basic example..."
	cd examples/basic && terraform plan

example-basic-apply:
	@echo "Applying basic example..."
	cd examples/basic && terraform apply

example-basic-destroy:
	@echo "Destroying basic example..."
	cd examples/basic && terraform destroy

example-advanced-init:
	@echo "Initializing advanced example..."
	cd examples/advanced && terraform init

example-advanced-plan:
	@echo "Planning advanced example..."
	cd examples/advanced && terraform plan

example-advanced-apply:
	@echo "Applying advanced example..."
	cd examples/advanced && terraform apply

example-advanced-destroy:
	@echo "Destroying advanced example..."
	cd examples/advanced && terraform destroy

# Documentation targets
docs:
	@echo "Generating documentation..."
	@echo "Documentation is maintained in README.md"

# Security check targets
security-check:
	@echo "Running security checks..."
	@echo "Consider using tools like:"
	@echo "  - tfsec"
	@echo "  - terrascan"
	@echo "  - checkov"

# Cost estimation
cost-estimate:
	@echo "Estimating costs..."
	@echo "Run: terraform plan -out=tfplan"
	@echo "Then: terraform show -json tfplan | jq '.planned_values.root_module.resources[] | select(.type | contains(\"aws_\")) | {type: .type, name: .name}'"

# Backup state
backup-state:
	@echo "Backing up Terraform state..."
	@if [ -f terraform.tfstate ]; then \
		cp terraform.tfstate terraform.tfstate.backup.$$(date +%Y%m%d_%H%M%S); \
		echo "State backed up successfully"; \
	else \
		echo "No terraform.tfstate file found"; \
	fi

# Show outputs
outputs:
	@echo "Showing Terraform outputs..."
	terraform output

# Show resources
resources:
	@echo "Showing Terraform resources..."
	terraform state list

# Import resources (example)
import-example:
	@echo "Example import command:"
	@echo "terraform import aws_ec2_transit_gateway.main tgw-12345678" 
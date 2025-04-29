1. Run terraform -version
2. Run terraform init to show how Terraform will load providers etc.
3. Show vars.tf, module_vars.tf, terraform.tfvars, rc-controller-1a.tfvars
4. Show the various .tf files making up the module
5. Run terraform plan without any parameters - show that optional variables are being asked for (only terraform.tfvars is being loaded automatically)
6. Run terraform apply -var-file=rc-controller-1a.tfvars
7. Run terraform destroy -var-file=rc-controller-1a.tfvars
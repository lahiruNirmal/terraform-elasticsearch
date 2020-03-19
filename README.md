# terraform-elasticsearch

## Description
This repository is created for creating an VPC based Elasticsearch cluster using Terraform. 

## Prequisities
1. Install terraform.
2. Install AWS CLI.
3. Configure AWS credentials for your local machine. (Get the programatic access credentials from IAM console.)

## Steps
1. Clone the repo into your local machine.
2. Add following commands using bash shell. 
    
    1. cd terraform-elasticsearch/
    2. vi terraform.tfvars
    3. Add following two values for variables.
        - vpc = "VPC id you want elasticsearch cluster access to"
        - environment = "dev/uat/prod" (You can edit the regions you want ES cluster according the environment you desire using variable REIGION in vars.tf file).
    4. terraform init
    5. terraform plan
    6. terraform apply

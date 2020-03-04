terraform {
  source = "git::git@github.com:ilyassmoutite/terraform-aws-security-group.git"
}

include {
  path = "${find_in_parent_folders()}"
}

dependencies {
  paths = ["../vpc"]
}

inputs = {
  # Name of security group
  # type: string
  name = "Admin Node"

  # ID of the VPC where to create security group
  # type: string
  vpc_id = "" # @tfvars:terraform_output.vpc.vpc_id

  
}

# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "stage"
  subnets = ["subnet-0d103fbc95cca87bb","subnet-0c94a345bc8c275bf","subnet-04669e18c7d855b83"]
  vpc_id      = "vpc-0468273db3b28ac62"
  gateway_security_group = "sg-09964ba3c991258e6"
}

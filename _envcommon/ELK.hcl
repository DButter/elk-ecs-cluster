# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This is the common component configuration for webserver-cluster. The common variables for each environment to
# deploy webserver-cluster are defined here. This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
  subnets = local.environment_vars.locals.subnets
  vpc_id = local.environment_vars.locals.vpc_id
  gateway_security_group = local.environment_vars.locals.gateway_security_group
}

terraform {
  source = "${dirname(find_in_parent_folders())}/modules/ELK"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  name = "ELK-${local.env}"
  subnets = local.subnets
  vpc_id = local.vpc_id
  webaccess_security_groups = [local.gateway_security_group]
  dns = "${local.env}.com"
  tags = {
    name = "ELK-${local.env}"
  }
}

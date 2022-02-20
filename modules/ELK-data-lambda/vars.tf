variable "name" {
  description = "name your lambda"
  type        = string
}

variable "tags" {
  description = "tags to add to everything"
  type        = map
  default = null
}

variable "subnets" {
  description = "list of subnet id's"
  type        = list(string)
}

variable "vpc_id" {
  description = "id of your favourite vpc"
  type        = string
}

variable "webaccess_security_groups" {
  description = "list of security groups that the lambda is allowed to access to"
  type        = list(string)
  default = null
}

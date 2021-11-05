
variable "name" {
  description = "name your elk cluster"
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

variable "webaccess_cidr_blocks" {
  description = "list of allowed cidrs to access the elastic webfrontend"
  type        = list(string)
  default = null
}

variable "webaccess_security_groups" {
  description = "list of security groups that are allowed to access the elastic webfrontend"
  type        = list(string)
  default = null
}

variable "dns" {
  description = "private dns name"
  type        = string
}

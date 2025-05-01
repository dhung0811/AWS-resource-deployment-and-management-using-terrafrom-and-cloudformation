variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet" {
  type = string
}

variable "private_subnet" {
  type = string
}


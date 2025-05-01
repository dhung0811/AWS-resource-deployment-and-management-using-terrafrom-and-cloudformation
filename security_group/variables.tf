variable "name" {
  description = "Name of the Security Group"
  type = string
}


variable "vpc_id" {
  type = string
}


variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = list(string)
    security_groups = list(string)
  }))
  default = []
}

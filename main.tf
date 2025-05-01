provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./vpc"
  vpc_cidr_block = "10.0.0.0/16"
  private_subnet = "10.0.1.0/24"
  public_subnet = "10.0.4.0/24"
}


module "public_sg" {
  source = "./security_group"
  name = "public-sg"
  vpc_id = module.vpc.vpc_id


  ingress_rules = [{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_block = ["113.176.49.91/32"]
    security_groups = []
  }
  ]
}


module "private_sg" {
  source = "./security_group"
  name = "private-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_block = []
    security_groups = [module.public_sg.security_group_id]
  }]
}


module "public_ec2" {
  source                = "./ec2"
  name                  = "public-instance"
  ami                   = "ami-0f88e80871fd81e91"
  instance_type         = "t2.micro"
  subnet_id             = module.vpc.public_subnet_id
  security_group_ids    = [module.public_sg.security_group_id]
  key_name              = "lab1-key"
  associate_public_ip   = true
}


module "private_ec2" {
  source                = "./ec2"
  name                  = "private-instance"
  ami                   = "ami-0f88e80871fd81e91"
  instance_type         = "t2.micro"
  subnet_id             = module.vpc.private_subnet_id
  security_group_ids    = [module.private_sg.security_group_id]
  key_name              = "lab1-key"
  associate_public_ip   = false
}
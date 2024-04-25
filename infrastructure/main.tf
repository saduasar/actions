provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  region = "us-east-1"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
  cidr_block = {
    cidr1 = "10.0.1.0/24"
    cidr2 = "10.0.2.0/24"
    cidr3 = "10.0.3.0/24"
  }
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
  region = "us-east-1"
}

module "ngw" {
  source           = "./modules/natgateway"
  internet_gateway = module.igw.internet_gateway
  public_subnet_id = module.subnets.public_subnet_id
}

module "routeable" {
  source              = "./modules/routetables"
  internet_gateway_id = module.igw.internet_gateway_id
  nat_gateway_id      = module.ngw.nat_gateway_id
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.subnets.public_subnet_id
  private_subnet_id   = module.subnets.private_subnet_id
  public_subnet1_id   = module.subnets.public_subnet1_id
  private_subnet1_id  = module.subnets.private_subnet1_id
}

module "securitygroups" {
  source = "./modules/securitygroups"
  vpc_id = module.vpc.vpc_id
}

#module "instances" {
# source                 = "./modules/instances"
#backend-servers_sg_id  = module.securitygroups.backend-servers_sg_id
#frontend-servers_sg_id = module.securitygroups.frontend-servers_sg_id
#public_subnet_id       = module.subnets.public_subnet_id
#private_subnet_id      = module.subnets.private_subnet_id
#vpc_id                 = module.vpc.vpc_id
#public_subnet1_id      = module.subnets.public_subnet1_id
#instance_type1         = var.instance_type1
#}

#module "hostedzones" {
# source                     = "./modules/hostedzones"
# vpc_id                     = module.vpc.vpc_id
# rds-address-endpoint       = module.mysql-rds.rds-address-endpoint
# memcached-endpoint         = module.memcached.memcached-endpoint
# rabbit-primary_console_url = module.rabbitmq.rabbit-primary_console_url
#}

/*
module "ecs" {
  source                 = "./modules/ecs"
  vpc_id                 = module.vpc.vpc_id
  region                 = "us-east-1"
  public_subnet1_id      = module.subnets.public_subnet1_id
  frontend-servers_sg_id = module.securitygroups.frontend-servers_sg_id
  private_subnet_id      = module.subnets.private_subnet_id
  backend-servers_sg_id  = module.securitygroups.backend-servers_sg_id
  public_subnet_id       = module.subnets.private_subnet_id
}
*/

/*
module "mysql-rds" {
  source                 = "./modules/rds"
  vpc_id                 = module.vpc.vpc_id
  public_subnet1_id      = module.subnets.public_subnet1_id
  frontend-servers_sg_id = module.securitygroups.frontend-servers_sg_id
  private_subnet_id      = module.subnets.private_subnet_id
  backend-servers_sg_id  = module.securitygroups.backend-servers_sg_id
  public_subnet_id       = module.subnets.private_subnet_id
  private_subnet1_id     = module.subnets.private_subnet1_id
  instance_type1         = var.instance_type1
}
*/

/*
module "memcached" {
  source                 = "./modules/memcached"
  public_subnet1_id      = module.subnets.public_subnet1_id
  frontend-servers_sg_id = module.securitygroups.frontend-servers_sg_id
  private_subnet_id      = module.subnets.private_subnet_id
  backend-servers_sg_id  = module.securitygroups.backend-servers_sg_id
  public_subnet_id       = module.subnets.private_subnet_id
  private_subnet1_id     = module.subnets.private_subnet1_id
}
*/

/*
module "rabbitmq" {
  source                 = "./modules/rabbitmq"
  public_subnet1_id      = module.subnets.public_subnet1_id
  frontend-servers_sg_id = module.securitygroups.frontend-servers_sg_id
  private_subnet_id      = module.subnets.private_subnet_id
  backend-servers_sg_id  = module.securitygroups.backend-servers_sg_id
  public_subnet_id       = module.subnets.private_subnet_id
  private_subnet1_id     = module.subnets.private_subnet1_id
}
*/

module "eks" {
  source = "./modules/eks"
  public_subnet1_id      = module.subnets.public_subnet1_id
  private_subnet_id      = module.subnets.private_subnet_id
  public_subnet_id       = module.subnets.private_subnet_id
  private_subnet1_id     = module.subnets.private_subnet1_id
  eks-sg_id = module.securitygroups.eks-sg_id
}





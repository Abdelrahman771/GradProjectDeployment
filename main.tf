module "VPC" {
  source = "./terraformmodules/VPC"
  vpc-cidr = "10.0.0.0/16"
  vpc-tag-name = "TerraformProject"
  subnet-cidr-pub = ["10.0.0.0/24","10.0.2.0/24"]
  subnet-cidr-prv = ["10.0.1.0/24","10.0.3.0/24"]
  NAT-name="NGW"
  igw-name = "IGW"
  GW-cidr="0.0.0.0/0"
  PubRT-name="PublicRouteTable"
  PrivRT-name="PrivateRouteTable"
  AZ-State="available"
}


module "Eks-Ckuster" {
  source = "./terraformmodules/EKS"
  eks-cluster-subnets-id    = module.VPC.publicSubnets-ids
  eks-node-subnet_ids       = module.VPC.PrivateSubnets-ids
}

module "Instances" {
  source                    = "./terraformmodules/Bastion"
  instance-type             = "t2.micro"
  publicInstances-tag-name  = "Bastionhost01"
  vpc-id                    = module.VPC.vpcid
  publicSubnet_ID           = module.VPC.publicSubnets-ids[1]
  ami                       = "ami-0557a15b87f6559cf"            
}
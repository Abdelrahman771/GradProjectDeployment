variable "vpc-cidr" {
    type = string
}

variable "vpc-tag-name" {
    type = string
}


variable "subnet-cidr-pub" {
    type = list
    default = []
}

variable "subnet-cidr-prv" {
    type = list
    default = []
}

variable "GW-cidr" {
    type = string
}

variable "PubRT-name" {
    type = string
}
variable "PrivRT-name" {
    type = string
}

variable "NAT-name" {
    type = string
}

variable "igw-name" {
    type = string
}

variable "AZ-State" {
  type = string
}
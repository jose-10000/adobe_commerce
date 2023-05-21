# Variables
# Region
variable "aws_region" {
  default = "eu-west-1"
}

# Profile, used to authenticate to AWS.
# This is the profile name in ~/.aws/credentials
variable "aws_profile" {
  default = "terraform-course"
}

# Instance
variable "instance_name" {
  description = "Name of the instance to be created"
  default     = "adobe-commerce"
}

variable "instance_type" {
  default = "t3.xlarge" # t3.xlarge (4 vCPU, 16 GB RAM). Next best is t3.2xlarge (4 vCPU, 32 GB RAM)
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will be created in"
  default     = "subnet-adobe-commerce"
}

variable "ami_id" {
  description = "The AMI to use"
  default     = "ami-01dd271720c1ba44f" # Ubuntu 22.04 LTS // eu-west-1
}

variable "number_of_instances" {
  description = "number of instances to be created"
  default     = 1
}

# VPC and subnet.
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default     = "eu-west-1a"
}
variable "public_key_path" {
  description = "Public key path"
  default     = "~/.ssh/id_rsa.pub"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Production"
}

# Security group
variable "ingressports" {
  type    = list(number)
  default = [8080, 22, 80, 9200]
}

variable "ingressports_udp" {
  type    = list(number)
  default = [443]
}


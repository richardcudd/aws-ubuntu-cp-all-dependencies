variable "private_key" {  
  default = "~/.ssh/rcudd-ireland-key.pem"
}

variable "ansible_user" {
  default = "ubuntu"
}

variable "instance_name" {
  default = "rcudd-ubuntu-confluent-platform"
}

variable "ami_image" {
  default = "ami-0d75513e7706cf2d9"
}

variable "instance_size" {
  default = "t2.2xlarge"
}

variable "key_name" {
  default = "rcudd-ireland-key"
}

variable "region" {
  default = "eu-west-1"
}

variable "instance_owner" {
  default = "Rich Cudd"
}

variable "security_group" {
  default = "rcudd-security-group"
}

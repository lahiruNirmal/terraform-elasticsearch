variable "REIGION" {
  type = "map"
  default = {
      dev = "ap-south-1"
      uat = "ap-southeast-2"
      prod = "ap-southeast-2"
  }
}

variable "environment" {
  default = "dev"
}

variable "vpc" {
  default = "vpc-71b0c618"
}



variable "region" {
  default = "us-east-1"
}

# core VPC paramters 
variable "vpc_cidr" {
  default = "10.100.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for all subnets by name"
  type = object({
    private-us-east-1a = string
    private-us-east-1b = string
    public-us-east-1a  = string
    public-us-east-1b  = string
  })
  default = {
    private-us-east-1a = "10.100.0.0/19"
    private-us-east-1b = "10.100.32.0/19"
    public-us-east-1a  = "10.100.64.0/19"
    public-us-east-1b  = "10.100.96.0/19"
  }
}

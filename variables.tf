


variable "vpc_id" {
    description = "VPC to connect to, used for a security group"
    type = "string"
}

variable "security_groups" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of subnet IDs"
  type        = list(string)
}


// variable "log_bucket_name" {
//     description = "Name of the S3 bucket for VPC logs"
//     type = "string"
// }

variable "type" {
    description = "LB Type (defaults to 'application'"
    default = "application"
}


variable "prefix" {
    description = "a prefix for resources to be identified"
    default = "lb-"
}


// 
// Tags 
//

variable "name" {
    default = "generic-ec2"
}

variable "tags" {
    default = {
        "project":"aws-certs",
        "owner" :"icullinane",
        "environment" : "dev"
    }
}



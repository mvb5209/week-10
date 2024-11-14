# variable "ENVIRONMENT" {
  
# }
# variable "INSTANCE_TYPE" {
  
# }
# variable "REGION" {
  
# }

variable "ENVIRONMENT" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"  # You can set a default or leave it empty
}

variable "INSTANCE_TYPE" {
  description = "The type of EC2 instance to use (e.g., t2.micro, m5.large)"
  type        = string
  default     = "t2.micro"
}

variable "REGION" {
  description = "The AWS region to deploy the resources to (e.g., us-east-1, us-west-2)"
  type        = string
  default     = "us-east-1"
}

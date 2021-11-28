variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ec_2_instance"
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

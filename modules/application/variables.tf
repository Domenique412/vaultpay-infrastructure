variable "vpc_id" {
  type        = string
  description = "Network identifier supplied by the parent module"
}

variable "project_name" {
  type        = string
  description = "Tags for the project and name"

}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs where the application load balancer runs"
}


variable "image_tag" {
  description = "Container image tag to deploy."
  type        = string
  default     = "latest"
}

variable "ecr_force_delete" {
  description = "When true, terraform destroy will delete the ECR repository even if it contains an image"
  type        = bool
  default     = false

}

variable "s3_force_destroy" {
  description = "When true, terraform destroy will delete the s3 bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "db_master_secret_arn" {
  type        = string
  description = "ARN of the database master secret supplied by the parent module"
}

variable "db_name" {
  type        = string
  description = "The database name for the current instance"
}

variable "db_endpoint" {
  type        = string
  description = "The database enpoint"

}

variable "db_port" {
  type        = number
  description = "Port on which the database accepts connections"
}

variable "app_security_group_id" {
  type        = string
  description = "ID of the application instance security group supplied by root"
}

variable "app_private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs where the application instances run"
}
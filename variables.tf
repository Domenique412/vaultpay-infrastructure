variable "main-vpc" {
  type        = string
  description = "Main VPC address for the subnets to branch off of"

}

variable "pub-subnet-a" {
  type        = string
  description = "Address for public subnet A"

}

variable "pub-subnet-b" {
  type        = string
  description = "Address for public subnet B"

}

variable "pub-route" {
  type        = string
  description = "Address for public route in igw"

}


variable "private-a-app" {
  type        = string
  description = "Address for private subnet application A"

}

variable "private-a-db" {
  type        = string
  description = "Address for private subnet database A"

}

variable "private-b-app" {
  type        = string
  description = "Address for private subnet application B"

}

variable "private-b-db" {
  type        = string
  description = "Address for private subnet database A"

}

variable "project_name" {
  type        = string
  description = "Tags for the project and name"

}

variable "app_private_subnet_cidrs" {
  type        = list(string)
  description = "Application private subnet ip addresses"

}


variable "db_name" {
  type        = string
  description = "The database name for the current instance"
}

variable "db_username" {
  type        = string
  description = "The database master username"

}
variable "multi_az" {
  type        = bool
  description = "Deploy the RDS instance across multiple availability zones"

}
variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain a backup"

}
variable "skip_final_snapshot" {
  type        = bool
  description = "Whether to skip a final snapshot when the instance is destroyed"

}
variable "deletion_protection" {
  type        = bool
  description = "Whether the deletion protection is enabled in RDS"

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
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



 
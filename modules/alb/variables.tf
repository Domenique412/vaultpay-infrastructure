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

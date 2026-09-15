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
  type = string
  description = "Tags for the project and name"
  
}
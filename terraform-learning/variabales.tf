variable "bucket_name" {
  type        = string
  description = "naming the bucket for s3"
  default     = "bucket_name"
}



variable "tags" {
    type = map(string)
    description = "project and owner name tag"
    
  
}
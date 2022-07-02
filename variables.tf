variable "aws-region"{
    description =   "Region de AWS."
    default     =   "us-east-1"
}
variable "bucket_prefix" {
  type = string
  description = "Creación de bucket para proyecto"
  default =  "songrecomendationgrouptree.com"
}
variable "acl" {
    type = string
    description = "default public"
    default = "public-read"
}
variable "versioning" {
  type = bool
  description = "state of versioning"
  default = true
}
variable "policy" {
    type  =   string
    description = "Archivo de politica Json"
    default = "policy.json"
}
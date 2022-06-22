variable "aws-region"{
    description =   "Region de AWS."
    default     =   "us-east-1"
}
variable "bucket_prefix" {
  type = string
  description = "Creación de bucket para proyecto"
  default =  "SongRecomendation.com"
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
variable "iam_for_lambda" {
  description = "politica de iam para funcion lambda"
  name  = "iam_for_lambda_recognition"
}
variable "name_for_lambda"{
  description = "Nombre para funcion lambda"
  name        = "lambda_recognition"
}
variable "aws-region"{
    description =   "Region de AWS."
    default     =   "us-east-1"
}
variable "bucket_prefix" {
  type = string
  description = "Creación de bucket para proyecto"
  default =  "SongRecomendation.com"
}
variable "bucket_prefix_for_lambda" {
  type = string
  description = "Creación de bucket privado para lambda"
  default =  "emotionrecognition"
}
variable "acl" {
    type = string
    description = "default public"
    default = "public-read"
}
variable "acl_lambda_private" {
    type = string
    description = "default public"
    default = "private"
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
  type          = string
  description   = "politica de iam para funcion lambda"
  default  = "iam_for_lambda_recognition"
}
variable "name_for_lambda"{
  type        = string
  description = "Nombre para funcion lambda"
  default     = "lambda_recognition"
}
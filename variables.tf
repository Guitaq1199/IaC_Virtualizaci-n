variable "aws-region"{
    description =   "Region de AWS."
    default     =   "us-east-1"
}
#Nombre de bucket para lambda de reconocimiento
variable "bucket_prefix_lambda_recognition" {
  type = string
  description = "Creación de bucket para lambda de reconocimiento"
  #default =  "storageimages2023"
  default =  "storageimages2022"
}
#Nombre de bucket de website
variable "bucket_prefix" {
  type = string
  description = "Creación de bucket para proyecto"
  default =  "songrecomendationgrouptree.com"
}
#Nombre de bucket de lambda de dynamo
variable "bucket_prefix_lambda_Dynamo" {
  type = string
  description = "Creación de bucket para base de datos de dynamo"
  default =  "lambdadynamosongrecognition"
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

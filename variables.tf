variable "application_role" {
  description = "The name of the application role, e.g. app_server"
  type        = string
  default     = "api-gateway"
}

variable "application_service" {
  description = "The name of the application service, e.g. infrastructure"
  type        = string
}

variable "compliance" {
  description = "An identifier for workloads designed to adhere to specific compliance requirements. none/pci"
  type        = string
  default     = "pci"
}

variable "confidentiality" {
  description = "An identifier for the specific data-confidentiality level a resource supports. public/internal/confidential/highly confidential"
  type        = string
  default     = "highly confidential"
}

variable "environment" {
  description = "The name of your environment, e.g. /dev/test/uat/prod etc"
  type        = string
}

variable "prefix" {
  description = "The prefix for the domain name, e.g. api"
  type        = string
  default     = "api"
}

variable "private_subnet_ids" {
  description = "The private subnet ids associated with the vpc"
  type        = list(string)
}

variable "project" {
  description = "The name of your application project, e.g. shared, supplier"
  type        = string
}

variable "public_zone_name" {
  description = "The public zone that the domain name will be placed within"
  type        = string
}

variable "vpc_id" {
  description = "The vpc_id that the endpoint is placed within"
  type        = string
}

variable "vpn_cidr_block" {
  description = "The cidr block for the vpn"
  type        = string
  default     = "10.7.0.0/24"
}

variable "location" {
  # Variables (You can modify these as per your needs)
  default = "Central India"
}


variable "blob_container_name" {
  default = "b-si-gokeodbsws"
}

variable "vnet_name" {
  default = "vnet-prod-01"
}

variable "subnet_name" {
  default = "vnet-prod-01"
}

variable "nsg_name" {
  default = "nsg-prod-01"
}

# Azure Authentication Variables
variable "client_id" {
  description = "The client ID of the Azure service principal"
  type        = string
}

variable "client_secret" {
  description = "The client secret of the Azure service principal"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID of the Azure subscription"
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID of the Azure subscription"
  type        = string
}
